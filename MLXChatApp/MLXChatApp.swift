//
//  MLXChatApp.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI
import LLMChatKit

@main
struct MLXChatApp: App {
  @State private var viewModel = ChatListViewModel(
    chatEngine: LLMChatService(modelConfiguration: .llama3_2_3B_4bit)
  )

  var body: some Scene {
    WindowGroup {
      ChatListView(viewModel: viewModel)
    }
  }
}
