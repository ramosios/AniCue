//
//  MinimumScoreSliderView.swift
//  AniCue
//
//  Created by Jorge Ramos on 03/07/25.
//
import SwiftUI
struct MinimumScoreSliderView: View {
    let icon: String
    let question: String
    let explanation: String
    @Binding var minimumScore: Double
    @Binding var showingHelp: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text(question)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 8) {
                Slider(value: $minimumScore, in: 5...8, step: 0.5) {
                    Text("Minimum Score")
                }
                HStack {
                    Text("Minimum Score: ")
                    Text(String(format: "%g", minimumScore))
                            .bold()
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
        .overlay(
            VStack(alignment: .trailing, spacing: 4) {
                Button(
                    action: {
                        showingHelp.toggle()
                    },
                    label: {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(10)
                    }
                )
                .zIndex(2)
                if showingHelp {
                    Text(explanation)
                        .font(.callout)
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .frame(maxWidth: 220, alignment: .trailing)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }, alignment: .topTrailing
        )
    }
}
