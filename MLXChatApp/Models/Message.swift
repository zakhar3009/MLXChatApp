//
//  Message.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation

struct Message: Identifiable, Hashable {
  enum Role: Hashable {
    case user
    case assistant
  }

  enum Status: Hashable {
    case complete
    case streaming
    case failed
  }

  let id: UUID
  let role: Role
  let text: String
  let status: Status

  init(
    id: UUID = UUID(),
    role: Role,
    text: String,
    status: Status = .complete
  ) {
    self.id = id
    self.role = role
    self.text = text
    self.status = status
  }
}
