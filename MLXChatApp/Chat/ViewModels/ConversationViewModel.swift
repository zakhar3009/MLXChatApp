//
//  ConversationViewModel.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation
import LLMChatKit
import Observation

@MainActor
@Observable
final class ConversationViewModel: Identifiable {
  private(set) var chat: Chat
  private(set) var isGenerating = false
  var inputText = ""

  var id: Chat.ID {
    chat.id
  }

  var canSend: Bool {
    !inputText.isEmpty && !isGenerating
  }
  
  private let chatEngine: any ChatEngine
  private var sessionId: SessionID?
  private var sendTask: Task<Void, Never>?
  
  private var filteredInput: String {
    inputText.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  init(chatEngine: any ChatEngine, chat: Chat) {
    self.chatEngine = chatEngine
    self.chat = chat
  }
  
  func sendMessage() {
    guard canSend else { return }
    let text = filteredInput
    inputText = ""
    isGenerating = true
    sendTask = Task {
      await generate(prompt: text)
    }
  }

  func stopGeneration() {
    sendTask?.cancel()
  }

  func cleanup() {
    sendTask?.cancel()
    guard let sessionId else { return }
    Task {
      await chatEngine.deleteSession(with: sessionId)
    }
  }
  
  private func generate(prompt: String) async {
    defer { isGenerating = false }
    do {
      let session = try await resolvedSessionId()
      chat.messages.append(Message(role: .user, text: prompt))
      chat.messages.append(Message(role: .assistant, text: "", status: .streaming))
      let assistantIndex = chat.messages.count - 1
      var responseText = ""
      let stream = try await chatEngine.sendMessage(prompt, in: session)
      for try await chunk in stream {
        responseText += chunk
        chat.messages[assistantIndex] = chat.messages[assistantIndex].replacing(text: responseText)
      }
      chat.messages[assistantIndex] = chat.messages[assistantIndex].replacing(status: .complete)
    } catch {
      markLastAssistantMessageFailed()
    }
  }

  private func resolvedSessionId() async throws -> SessionID {
    if let sessionId {
      return sessionId
    }
    let newSessionId = try await chatEngine.createSession()
    sessionId = newSessionId
    return newSessionId
  }

  private func markLastAssistantMessageFailed() {
    guard
      let lastIndex = chat.messages.indices.last,
      chat.messages[lastIndex].role == .assistant
    else { return }
    chat.messages[lastIndex] = chat.messages[lastIndex].replacing(status: .failed)
  }
}
