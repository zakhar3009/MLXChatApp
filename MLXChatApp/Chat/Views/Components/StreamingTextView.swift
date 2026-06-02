//
//  StreamingTextView.swift
//  MLXChatApp
//
//  Created by Zakhar Litvinchuk on 01.06.2026.
//

import SwiftUI

struct StreamingTextView: NSViewRepresentable {
  let text: String

  func makeNSView(context: Context) -> NSTextView {
    let textView = NSTextView()
    textView.isEditable = false
    textView.drawsBackground = false
    textView.font = .preferredFont(forTextStyle: .body)
    textView.textContainer?.widthTracksTextView = true
    return textView
  }

  func updateNSView(_ nsView: NSTextView, context: Context) {
    nsView.string = text
  }

  func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSTextView, context: Context) -> CGSize? {
    guard let width = proposal.width,
          let container = nsView.textContainer,
          let layout = nsView.layoutManager
    else { return nil }
    nsView.string = text
    container.containerSize = CGSize(width: width, height: .greatestFiniteMagnitude)
    layout.ensureLayout(for: container)
    return CGSize(width: width, height: layout.usedRect(for: container).height)
  }
}
