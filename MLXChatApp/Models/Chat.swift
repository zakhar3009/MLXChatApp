//
//  Chat.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation

struct Chat: Identifiable, Hashable {
  let id: UUID
  let title: String
  let messages: [Message]

  init(
    id: UUID = UUID(),
    title: String,
    messages: [Message] = []
  ) {
    self.id = id
    self.title = title
    self.messages = messages
  }
}
