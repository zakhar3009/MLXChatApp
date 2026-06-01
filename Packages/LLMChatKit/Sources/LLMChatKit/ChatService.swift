//
//  ChatService.swift
//  LLMChatKit
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation
import HuggingFace
import MLXHuggingFace
import MLXLLM
import MLXLMCommon
import Tokenizers

public actor LLMChatService: ChatEngine {
  private enum ModelState {
    case notLoaded
    case loading(Task<ModelContainer, Error>)
    case loaded(ModelContainer)
  }

  private let modelConfiguration: ModelConfiguration
  private let generationParams: GenerateParameters

  private var modelState: ModelState = .notLoaded
  private var sessions: [SessionID: ChatSession] = [:]
  private var generationTasks: [SessionID: Task<Void, Never>] = [:]

  public init(
    modelConfiguration: ChatModelConfiguration,
    generationConfiguration: GenerationConfiguration = .init()
  ) {
    self.modelConfiguration = modelConfiguration.modelConfiguration
    self.generationParams = generationConfiguration.generateParameters
  }

  public func loadModelIfNeeded() async throws {
    _ = try await modelContainer()
  }

  public func createSession() async throws -> SessionID {
    let model = try await modelContainer()
    let sessionId = UUID()
    sessions[sessionId] = ChatSession(
      model,
      generateParameters: generationParams
    )
    return sessionId
  }

  public func deleteSession(with id: SessionID) async {
    await stopGeneration(in: id)
    sessions.removeValue(forKey: id)
  }

  public func sendMessage(
    _ message: String,
    in sessionId: SessionID
  ) async throws -> AsyncThrowingStream<String, Error> {
    guard let session = sessions[sessionId] else {
      throw ChatError.sessionNotFound
    }
    generationTasks[sessionId]?.cancel()
    return AsyncThrowingStream { continuation in
      let task = Task {
        do {
          for try await chunk in session.streamResponse(to: message) {
            try Task.checkCancellation()
            continuation.yield(chunk)
          }
          continuation.finish()
        } catch is CancellationError {
          continuation.finish()
        } catch {
          continuation.finish(throwing: ChatError.generationFailed(underlying: error))
        }
        generationTasks[sessionId] = nil
      }
      generationTasks[sessionId] = task
      continuation.onTermination = { _ in
        task.cancel()
      }
    }
  }

  public func stopGeneration(in sessionId: SessionID) async {
    generationTasks[sessionId]?.cancel()
    generationTasks.removeValue(forKey: sessionId)
  }

  private func modelContainer() async throws -> ModelContainer {
    switch modelState {
    case .notLoaded:
      let loadingTask = Task {
        try await #huggingFaceLoadModelContainer(
          configuration: modelConfiguration
        )
      }
      modelState = .loading(loadingTask)
      do {
        let container = try await loadingTask.value
        modelState = .loaded(container)
        return container
      } catch {
        modelState = .notLoaded
        throw ChatError.modelLoadFailed(underlying: error)
      }

    case .loading(let task):
      do {
        return try await task.value
      } catch {
        throw ChatError.modelLoadFailed(underlying: error)
      }

    case .loaded(let container):
      return container
    }
  }
}

private extension ChatModelConfiguration {
  var modelConfiguration: ModelConfiguration {
    switch self {
    case .llama3_2_3B_4bit:
      LLMRegistry.llama3_2_3B_4bit
    }
  }
}

private extension GenerationConfiguration {
  var generateParameters: GenerateParameters {
    GenerateParameters(
      temperature: temperature,
      topP: topP
    )
  }
}
