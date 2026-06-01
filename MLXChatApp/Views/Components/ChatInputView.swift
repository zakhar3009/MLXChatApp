//
//  ChatInputView.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI

struct ChatInputView: View {
  @Binding var text: String
  let isGenerating: Bool
  let canSend: Bool
  let onSend: () -> Void
  let onStop: () -> Void

  var body: some View {
    HStack(alignment: .bottom, spacing: 12) {
      TextField("", text: $text, axis: .vertical)
        .lineLimit(1...5)
        .textFieldStyle(.plain)
        .fixedSize(horizontal: false, vertical: true)
        .padding(8)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))

      if isGenerating {
        Button(role: .destructive, action: onStop) {
          Label("Stop", systemImage: "stop.fill")
        }
        .buttonStyle(.bordered)
      } else {
        Button(action: onSend) {
          Label("Send", systemImage: "paperplane.fill")
        }
        .buttonStyle(.borderedProminent)
        .disabled(!canSend)
      }
    }
    .padding()
  }
}
