//
//  ChatListViewModel.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation
import LLMChatKit
import Observation

@MainActor
@Observable
final class ChatListViewModel {
  private let chatEngine: any ChatEngine

  var conversations: [ConversationViewModel]
  var selectedChatId: Chat.ID?

  var selectedConversation: ConversationViewModel? {
    guard let selectedChatId else { return nil }
    return conversations.first { $0.id == selectedChatId }
  }

  init(chatEngine: any ChatEngine) {
    self.chatEngine = chatEngine
    self.conversations = [ConversationViewModel(
      chatEngine: chatEngine,
      chat: Chat(title: "New Chat")
    )]
    selectedChatId = conversations.first?.id
  }

  func addConversation() {
    
  }

  func deleteConversation(with id: Chat.ID) {
    
  }
}
