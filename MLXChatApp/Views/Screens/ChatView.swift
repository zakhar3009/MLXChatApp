//
//  ChatView.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI

struct ChatView: View {
  let chat: Chat

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 12) {
        ForEach(chat.messages) { message in
          MessageView(message: message)
        }
      }
      .padding(20)
    }
    .navigationTitle(chat.title)
  }
}
