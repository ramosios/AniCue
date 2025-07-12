//
//  SuggestedPrompt.swift
//  AniCue
//
//  Created by Jorge Ramos on 11/07/25.
//
import Foundation

struct SuggestedPrompt: Identifiable {
    let id = UUID()
    let text: String
    let iconName: String
}

struct SuggestedPrompts {
    static let all: [SuggestedPrompt] = [
        SuggestedPrompt(text: "Top 10 action anime from the 90s", iconName: "flame.fill"),
        SuggestedPrompt(text: "Suggest some psychological thrillers", iconName: "brain.head.profile"),
        SuggestedPrompt(text: "What are some good romance anime?", iconName: "heart.fill"),
        SuggestedPrompt(text: "I'm looking for a sci-fi series", iconName: "sparkles")
    ]
}
