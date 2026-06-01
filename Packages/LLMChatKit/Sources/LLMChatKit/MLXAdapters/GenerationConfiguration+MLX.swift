//
//  GenerationConfiguration+MLX.swift
//  LLMChatKit
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import MLXLMCommon

extension GenerationConfiguration {
  var generateParameters: GenerateParameters {
    GenerateParameters(
      temperature: temperature,
      topP: topP
    )
  }
}
