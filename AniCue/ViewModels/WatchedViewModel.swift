//
//  WatchedViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 19/06/25.
//
import Foundation

class WatchedViewModel: ObservableObject {
    @Published private(set) var watched: [JikanAnime] = []

    private let filename = "watched_movies.json"

    init() {
        loadWatched()
    }

    func markAsWatched(_ anime: JikanAnime) {
        guard !watched.contains(where: { $0.malId == anime.malId }) else { return }
        watched.append(anime)
        saveWatched()
    }

    func isWatched(_ anime: JikanAnime) -> Bool {
        watched.contains(where: { $0.malId == anime.malId })
    }
    func remove(_ anime: JikanAnime) {
        watched.removeAll { $0.malId == anime.malId }
        saveWatched()
    }
    func clearAll() {
        watched.removeAll()
        saveWatched()
    }
    private func fileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
    }

    private func saveWatched() {
        do {
            let data = try JSONEncoder().encode(watched)
            try data.write(to: fileURL())
        } catch {
            print("❌ Failed to save watched animes: \(error)")
        }
    }

    private func loadWatched() {
        do {
            let data = try Data(contentsOf: fileURL())
            watched = try JSONDecoder().decode([JikanAnime].self, from: data)
        } catch {
            watched = []
        }
    }
}
