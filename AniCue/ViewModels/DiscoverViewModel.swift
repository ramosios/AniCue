//
//  DiscoverViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 15/06/25.
//
import Foundation

@MainActor
class DiscoverViewModel: ObservableObject {
    @Published var animes: [JikanAnime] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let openAIService = OpenAIService()
    private let jikaService = JikanService()
    func getRecommendations(for prompt: String, userPreferences: [String],avoiding animesToAvoid: [String]) async {
        isLoading = true
        errorMessage = nil
        animes = []

        do {
            let titles = try await openAIService.fetchAnimeTitles(prompt: prompt, userPreferences: userPreferences, excluding: animesToAvoid)
            self.animes = try await jikaService.fetchAnimes(for: titles)
        } catch let error as LocalizedError {
            self.errorMessage = error.errorDescription
        } catch {
            self.errorMessage = "Unexpected error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
