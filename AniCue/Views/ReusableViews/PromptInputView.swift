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

            TextEditor(text: $prompt)
                .frame(height: 100)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if prompt.isEmpty {
                            Text("e.g. dark psychological thrillers with mystery")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .allowsHitTesting(false)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                )

            Button(action: {
                guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                onSubmit()
            }) {
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
            }
        }
        .padding()
    }
}
