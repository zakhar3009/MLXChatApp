//
//  MessageView.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI

struct MessageView: View {
  let message: Message

  var body: some View {
    textContent
      .padding(10)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .frame(maxWidth: 500, alignment: alignment)
      .frame(maxWidth: .infinity, alignment: alignment)
  }

  @ViewBuilder
  private var textContent: some View {
    if message.status == .streaming {
      StreamingTextView(text: message.text)
    } else {
      Text(message.text)
        .textSelection(.enabled)
    }
  }

  private var alignment: Alignment {
    message.role == .user ? .trailing : .leading
  }

  private var backgroundColor: Color {
    message.role == .user ? Color.accentColor.opacity(0.14) : Color.secondary.opacity(0.12)
  }
}
