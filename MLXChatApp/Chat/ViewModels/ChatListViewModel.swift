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
  enum ModelLoadingState {
    case notLoaded
    case loading(Task<Void, Never>)
    case ready
    case failed(Error)
  }
  
  private let chatEngine: any ChatEngine
  
  private(set) var modelLoadingState: ModelLoadingState = .notLoaded
  private(set) var conversations: [ConversationViewModel]
  var selectedChatId: Chat.ID?
  
  var selectedConversation: ConversationViewModel? {
    guard let selectedChatId else { return nil }
    return conversations.first { $0.id == selectedChatId }
  }
  
  init(chatEngine: any ChatEngine) {
    self.chatEngine = chatEngine
    let initial = ConversationViewModel(
      chatEngine: chatEngine,
      chat: Chat(title: "New Chat")
    )
    self.conversations = [initial]
    selectedChatId = initial.id
  }
  
  func loadModel() {
    switch modelLoadingState {
    case .notLoaded, .failed:
      let task = Task {
        do {
          try await chatEngine.loadModelIfNeeded()
          modelLoadingState = .ready
        } catch {
          modelLoadingState = .failed(error)
        }
      }
      modelLoadingState = .loading(task)
    case .loading, .ready:
      return
    }
  }

  func addConversation() {
    let conversation = ConversationViewModel(
      chatEngine: chatEngine,
      chat: Chat(title: "New Chat")
    )
    conversations.append(conversation)
    selectedChatId = conversation.id
  }

  func deleteConversation(with id: Chat.ID) {
    guard let index = conversations.firstIndex(where: { $0.id == id }) else { return }
    conversations[index].cleanup()
    conversations.remove(at: index)
    if selectedChatId == id {
      selectedChatId = conversations.last?.id
    }
  }
}
