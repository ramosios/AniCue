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
    @Published var noRecommendations = false
    private let openAIService: OpenAIServiceProtocol
    private let jikaService: JikanServiceProtocol
    init(openAIService: OpenAIServiceProtocol = OpenAIService(),
         jikaService: JikanServiceProtocol = JikanService()) {
        self.openAIService = openAIService
        self.jikaService = jikaService
    }
    func formatDataApiCalls(for prompt: String,preferences: UserPreferencesViewModel,favorites: WatchListViewModel,watched: WatchedViewModel) async {
        // Gets ids to avoid based on user's favorites and watched animes
        let avoid = (favorites.animes + watched.animes).map(\.malId)
        let preference = formatUserPreference(from: preferences.selectedAnswers)
        await getRecommendations(for: prompt, userPreferences: preference, avoiding: avoid)
    }
    func getRecommendations(for prompt: String, userPreferences: (startDate: String, endDate: String,format: String,minimumScore: Double), avoiding animesToAvoid: [Int]) async {
        isLoading = true
        errorMessage = nil
        animes = []
        noRecommendations = false
        do {
            let genres: [Int]
            do {
                genres = try await openAIService.fetchGenres(from: prompt)
            } catch {
                throw NSError(domain: "Genre Fetch Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch genres: \(error.localizedDescription)"])
            }

            let filteredAnimes: [JikanAnime]
            do {
                filteredAnimes = try await jikaService.fetchFilteredAnime(
                    genreIds: genres,
                    excludedMalIds: animesToAvoid,
                    startDate: userPreferences.startDate,
                    endDate: userPreferences.endDate,
                    limit: 25,
                    page: 1,
                    minimumScore: userPreferences.minimumScore,
                    type: userPreferences.format
                )
            } catch {
                throw NSError(domain: "Anime Fetch Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch filtered anime: \(error.localizedDescription)"])
            }

            do {
                let topAnimes = try await openAIService.recommendTopAnime(from: filteredAnimes, prompt: prompt)
                self.animes = topAnimes
                self.noRecommendations = topAnimes.isEmpty
            } catch {
                throw NSError(domain: "Recommendation Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get recommendations: \(error.localizedDescription)"])
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

}
