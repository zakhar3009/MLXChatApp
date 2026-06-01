//
//  GenerationConfiguration.swift
//  LLMChatKit
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import Foundation

public struct GenerationConfiguration: Sendable, Hashable {
  public let temperature: Float
  public let topP: Float
  
  public init(
    temperature: Float = 0.2,
    topP: Float = 0.95
  ) {
    self.temperature = temperature
    self.topP = topP
  }
}
