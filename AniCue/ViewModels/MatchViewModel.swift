//
//  MatchViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 12/08/25.
//
import SwiftUI

class MatchViewModel: ObservableObject {
    @ObservedObject var animeList = AnimeListManager.shared
    @Published var animes: [JikanAnime] = []
    @Published var cardOffsets: [Int: CGSize] = [:]
    @Published var errorMessage: String?

    enum SwipeDirection {
        case left, right
    }

    init() {
        loadAnimes()
    }

    func loadAnimes() {
        self.animes = animeList.downloaded
    }

    private func removeCard(at index: Int) {
        guard index >= 0 && index < animes.count else { return }
        let animeId = animes[index].id
        animes.remove(at: index)
        cardOffsets.removeValue(forKey: animeId)
    }
    func fetchPopularAnime(excludedMalIds: [Int] = [], limit: Int = 25, page: Int = 1) async {
            let service = JikanService()
            do {
                let popular = try await service.fetchMostPopularAnime(
                    excludedMalIds: excludedMalIds,
                    limit: limit,
                    page: page
                )
                DispatchQueue.main.async {
                    self.animes = popular
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }

    func swipeCard(for anime: JikanAnime) {
        guard let index = animes.firstIndex(where: { $0.id == anime.id }) else { return }
        let direction: SwipeDirection = (cardOffsets[anime.id]?.width ?? 0) > 0 ? .right : .left
        withAnimation(.spring()) {
            switch direction {
            case .left:
                cardOffsets[anime.id] = CGSize(width: -500, height: 0)
            case .right:
                cardOffsets[anime.id] = CGSize(width: 500, height: 0)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.removeCard(at: index)
        }
    }
}
