//
//  ChatView.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI

struct ChatView: View {
  @Bindable var viewModel: ConversationViewModel

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        LazyVStack(spacing: 12) {
          ForEach(viewModel.chat.messages) { message in
            MessageView(message: message)
          }
        }
        .padding(20)
      }

      ChatInputView(
        text: $viewModel.inputText,
        isGenerating: viewModel.isGenerating,
        canSend: viewModel.canSend,
        onSend: viewModel.sendMessage,
        onStop: viewModel.stopGeneration
      )
    }
    .navigationTitle(viewModel.chat.title)
  }
}
