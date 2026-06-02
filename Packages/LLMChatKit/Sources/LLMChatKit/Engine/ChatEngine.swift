//
//  ChatEngine.swift
//  LLMChatKit
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation

public typealias SessionID = UUID

/// Manages the lifecycle of an LLM-backed chat engine.
public protocol ChatEngine {

  /// Loads the model into memory if not already loaded. Safe to call multiple times.
  func loadModelIfNeeded() async throws

  /// Creates a new isolated chat session with its own conversation history.
  ///
  /// - Returns: A unique identifier for the created session.
  /// - Throws: If the model is not loaded or session initialisation fails.
  func createSession() async throws -> SessionID

  /// Cancels any in-progress generation and releases the session.
  ///
  /// - Parameter id: The identifier of the session to remove.
  func deleteSession(with id: SessionID) async

  /// Sends a message and returns a stream of generated tokens.
  ///
  /// Cancelling the consuming `Task` stops generation automatically.
  ///
  /// - Parameters:
  ///   - message: The user message to send.
  ///   - sessionId: The session in which to send the message.
  /// - Returns: An `AsyncThrowingStream` of token strings.
  /// - Throws: ``ChatError/sessionNotFound`` or ``ChatError/generationFailed(underlying:)``.
  func sendMessage(
    _ message: String,
    in sessionId: SessionID
  ) async throws -> AsyncThrowingStream<String, Error>
}
