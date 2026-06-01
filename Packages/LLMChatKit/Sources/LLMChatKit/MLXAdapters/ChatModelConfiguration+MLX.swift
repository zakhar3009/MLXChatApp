//
//  ChatModelConfiguration+MLX.swift
//  LLMChatKit
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import MLXLLM
import MLXLMCommon

extension ChatModelConfiguration {
  var modelConfiguration: ModelConfiguration {
    switch self {
    case .llama3_2_3B_4bit:
      LLMRegistry.llama3_2_3B_4bit
    }
  }
}
