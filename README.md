# MLXChatApp

MLXChatApp is a local macOS chat app backed by `LLMChatKit`, a Swift package that wraps MLX language model loading, chat sessions, prompt generation, streaming responses, and cancellation.

## Build and Run

1. Open `MLXChatApp.xcodeproj` in Xcode.
2. Select the `MLXChatApp` scheme.
3. Run the app from Xcode.
4. On first launch, wait for the model to load. This can take longer the first time because dependencies and model assets may need to be downloaded.

## Implementation Summary

### LLMChatKit Package

The main implementation is in the local `LLMChatKit` package. It exposes a small app-facing API through `ChatEngine`, with `LLMChatService` as the concrete MLX-backed implementation.

`LLMChatKit` exposes the public chat service surface:

- `ChatEngine`
- `LLMChatService`
- `ChatModelConfiguration`
- `GenerationConfiguration`
- `ChatError`

`LLMChatService` is an actor that owns model lifecycle and session state. It loads the selected MLX model on demand, reuses an in-flight model loading task when multiple callers request the model at the same time, and keeps the loaded model container available for future sessions.

Each chat conversation creates a separate `ChatSession`, identified by `SessionID`. When the app sends a prompt, `LLMChatService` returns an `AsyncThrowingStream<String, Error>` so generated text can be consumed incrementally. Active generation tasks are tracked per session, which lets the app run parallel generations in different chats and stop generation for a specific chat without affecting other sessions.

The package keeps app-facing configuration independent from MLX-specific types. `ChatModelConfiguration` and `GenerationConfiguration` are mapped to MLX `ModelConfiguration` and `GenerateParameters` through internal adapter extensions. Service failures are mapped into `ChatError`, including model loading failures, missing sessions, and generation failures.

### App

The SwiftUI app uses an MVVM-style structure built with the Observation framework. `MLXChatApp.swift` creates one shared `LLMChatService` and injects it into `ChatListViewModel`, which owns model loading state, chat creation, chat deletion, and selected chat state.

Each conversation is represented by `ConversationViewModel`. It creates a session lazily through `ChatEngine`, sends prompts, stores streamed messages, exposes generation state for the input UI, and calls stop/delete methods when the user cancels generation or removes a chat.

The UI is split into a sidebar and detail area with `NavigationSplitView`. The sidebar lists chats and provides the new-chat action, while the detail view renders the selected conversation, message list, text input, and send/stop buttons.
