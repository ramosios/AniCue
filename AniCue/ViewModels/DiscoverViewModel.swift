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
    private let openAIService: OpenAIServiceProtocol
    private let jikaService: JikanServiceProtocol
    init(openAIService: OpenAIServiceProtocol = OpenAIService(),
         jikaService: JikanServiceProtocol = JikanService()) {
        self.openAIService = openAIService
        self.jikaService = jikaService
    }
    func getRecommendations(for prompt: String, userPreferences: (startDate: String?, endDate: String?), avoiding animesToAvoid: [Int]) async {
        isLoading = true
        errorMessage = nil
        animes = []

        let start = userPreferences.startDate ?? "2000-01-01"
        let end = userPreferences.endDate ?? "2024-12-31"

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
                    startDate: start,
                    endDate: end,
                    limit: 25,
                    page: 1,
                    minimumScore: 7.0
                )
            } catch {
                throw NSError(domain: "Anime Fetch Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch filtered anime: \(error.localizedDescription)"])
            }

            do {
                let topAnimes = try await openAIService.recommendTopAnime(from: filteredAnimes, prompt: prompt)
                self.animes = topAnimes
            } catch {
                throw NSError(domain: "Recommendation Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get recommendations: \(error.localizedDescription)"])
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

}
