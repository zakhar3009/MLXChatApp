//
//  Chat.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation

struct Chat: Identifiable, Hashable {
  let id: UUID
  var messages: [Message]

  var title: String {
    messages.first { $0.role == .user }?.text ?? "New Chat"
  }

  init(
    id: UUID = UUID(),
    messages: [Message] = []
  ) {
    self.id = id
    self.messages = messages
  }
}
