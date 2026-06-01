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
  private let chatEngine: any ChatEngine

  private(set) var chat: Chat
  var inputText = ""
  var isGenerating = false

  var id: Chat.ID {
    chat.id
  }

  var canSend: Bool {
    !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    && !isGenerating
  }

  init(chatEngine: any ChatEngine, chat: Chat) {
    self.chatEngine = chatEngine
    self.chat = chat
  }

  func sendMessage() {
    
  }

  func stopGeneration() {
    
  }
}
