//
//  PromptInputView.swift
//  TMDB
//
//  Created by Jorge Ramos on 08/06/25.
//
import SwiftUI

struct PromptInputView: View {
    @Binding var prompt: String
    var onSubmit: () -> Void
    @FocusState private var isFocused: Bool
    
    private let placeholders = [
            "e.g. dark psychological thrillers with mystery",
            "e.g. wholesome slice of life with comedy",
            "e.g. action-packed shonen with superpowers",
            "e.g. heartwarming romance with school setting",
            "e.g. mind-bending sci-fi adventures"
    ]
    @State private var placeholder: String

    init(prompt: Binding<String>, onSubmit: @escaping () -> Void) {
        self._prompt = prompt
        self.onSubmit = onSubmit
        _placeholder = State(initialValue: placeholders.randomElement() ?? "")
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "sparkles.tv.fill")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 28))
                Text("What's your anime vibe today?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }

            ZStack(alignment: .topLeading) {
                TextEditor(text: Binding(
                    get: { prompt },
                    set: { newValue in
                        prompt = String(newValue.prefix(200))
                    }
                ))
                .focused($isFocused)
                .frame(height: 100)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                )

                if prompt.isEmpty && !isFocused {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .allowsHitTesting(false)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Text("\(300 - prompt.count) characters remaining")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)

            Button(action: {
                guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                onSubmit()
            }, label: {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                    Text("Generate Anime Picks")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(14)
            })
        }
        .padding()
    }
}
