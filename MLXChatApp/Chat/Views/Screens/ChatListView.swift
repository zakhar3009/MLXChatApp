//
//  ChatListView.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI

struct ChatListView: View {
  @Bindable var viewModel: ChatListViewModel

  var body: some View {
    NavigationSplitView {
      sidebarView
    } detail: {
      detailView
    }
    .onAppear {
      viewModel.loadModel()
    }
  }
  
  private var sidebarView: some View {
    List(viewModel.conversations, selection: $viewModel.selectedChatId) { conversation in
      chatRow(for: conversation)
        .tag(conversation.id)
    }
    .navigationTitle("Chats")
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: viewModel.addConversation) {
          Label("New Chat", systemImage: "plus")
        }
      }
    }
  }

  private func chatRow(for conversation: ConversationViewModel) -> some View {
    ChatPreviewView(
      chat: conversation.chat,
      onDelete: {
        viewModel.deleteConversation(with: conversation.id)
      }
    )
  }
  
  @ViewBuilder
  private var detailView: some View {
    switch viewModel.modelLoadingState {
    case .notLoaded, .loading:
      modelLoadingView
    case .failed(let error):
      modelFailedView(error)
    case .ready:
      if let conversation = viewModel.selectedConversation {
        ChatView(viewModel: conversation)
      } else {
        emptyChatSelectionView
      }
    }
  }

  private var modelLoadingView: some View {
    ContentUnavailableView {
      Label("Loading Model", systemImage: "cpu")
    } description: {
      VStack(spacing: 12) {
        Text("Preparing the language model.\nThis may take a moment on first launch.")
          .multilineTextAlignment(.center)
        ProgressView()
      }
    }
  }

  private func modelFailedView(_ error: Error) -> some View {
    ContentUnavailableView {
      Label("Failed to Load Model", systemImage: "exclamationmark.triangle")
    } description: {
      Text(error.localizedDescription)
        .multilineTextAlignment(.center)
    } actions: {
      Button("Retry") {
        viewModel.loadModel()
      }
      .buttonStyle(.borderedProminent)
    }
  }

  private var emptyChatSelectionView: some View {
    ContentUnavailableView(
      "No Chat Selected",
      systemImage: "bubble.left.and.bubble.right",
      description: Text("Select a chat from the sidebar.")
    )
  }
}
