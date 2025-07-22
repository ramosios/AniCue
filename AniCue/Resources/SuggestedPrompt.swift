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
        SuggestedPrompt(text: "Suggest some psychological thrillers", iconName: "brain.head.profile"),
        SuggestedPrompt(text: "What are some good romance anime?", iconName: "heart.fill"),
        SuggestedPrompt(text: "I'm looking for a sci-fi series", iconName: "sparkles"),
        SuggestedPrompt(text: "Best slice of life anime to relax", iconName: "leaf.fill"),
        SuggestedPrompt(text: "Underrated anime gems?", iconName: "star.lefthalf.fill"),
        SuggestedPrompt(text: "Best anime with strong female leads", iconName: "person.fill"),
        SuggestedPrompt(text: "Anime like Studio Ghibli films", iconName: "film.fill"),
        SuggestedPrompt(text: "Funny anime to binge-watch", iconName: "face.smiling"),
        SuggestedPrompt(text: "Anime with amazing soundtracks", iconName: "music.note"),
        SuggestedPrompt(text: "Dark fantasy anime recommendations", iconName: "moon.stars.fill"),
        SuggestedPrompt(text: "Anime with deep philosophical themes", iconName: "book.closed.fill"),
        SuggestedPrompt(text: "Feel-good anime to lift your mood", iconName: "sun.max.fill"),
        SuggestedPrompt(text: "Anime with beautiful animation", iconName: "paintbrush.fill"),
        SuggestedPrompt(text: "Wholesome anime about friendship", iconName: "hands.clap.fill"),
        SuggestedPrompt(text: "Anime with clever plot twists", iconName: "arrow.triangle.branch"),
        SuggestedPrompt(text: "Anime that made you cry", iconName: "drop.fill"),
        SuggestedPrompt(text: "Cozy anime to watch on a rainy day", iconName: "cloud.rain.fill"),
        SuggestedPrompt(text: "Anime with unique world-building", iconName: "globe.asia.australia.fill")
    ]
    static func randomThree() -> [SuggestedPrompt] {
        return Array(all.shuffled().prefix(3))
    }
}
