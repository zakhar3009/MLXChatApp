//
//  ChatEngine.swift
//  LLMChatKit
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation

public typealias SessionID = UUID

public protocol ChatEngine {
  func loadModelIfNeeded() async throws
  
  func createSession() async throws -> SessionID
  func deleteSession(with id: SessionID) async
  
  func streamResponse(
    for prompt: String,
    in sessionId: SessionID
  ) async throws -> AsyncThrowingStream<String, Error>
}
