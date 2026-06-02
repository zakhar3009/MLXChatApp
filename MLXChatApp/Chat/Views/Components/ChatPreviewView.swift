//
//  ChatPreviewView.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI

struct ChatPreviewView: View {
  let chat: Chat
  let onDelete: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      VStack(alignment: .leading, spacing: 4) {
        Text(chat.title)
          .font(.headline)
          .lineLimit(1)

        Text(previewText)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(2)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Button(role: .destructive, action: onDelete) {
        Label("Delete", systemImage: "trash")
      }
      .labelStyle(.iconOnly)
      .buttonStyle(.borderless)
      .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .contentShape(Rectangle())
  }

  private var previewText: String {
    guard let lastMessage = chat.messages.last else {
      return "No messages"
    }

    return lastMessage.text.isEmpty ? "Generating..." : lastMessage.text
  }
}
