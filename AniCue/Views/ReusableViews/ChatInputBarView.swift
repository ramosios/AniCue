//
//  ChatInputBarView.swift
//  AniCue
//
//  Created by Jorge Ramos on 11/07/25.
//
import SwiftUI
struct ChatInputBarView: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    var action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField("Type your message…", text: $text)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .focused(isFocused)
                .onSubmit(action)

            Button(action: action) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
                    .foregroundColor(text.isEmpty ? .gray : .accentColor)
            }
            .disabled(text.isEmpty)
        }
    }
}

