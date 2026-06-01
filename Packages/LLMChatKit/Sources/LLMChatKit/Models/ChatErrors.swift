//
//  ChatErrors.swift
//  LLMChatKit
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation

public enum ChatError: Error {
  case sessionNotFound
  case modelLoadFailed(underlying: any Error)
  case generationFailed(underlying: any Error)
}
