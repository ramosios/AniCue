//
//  WatchlistViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 19/06/25.
//
import Foundation
class WatchListViewModel: ObservableObject {
    @Published private(set) var watchList: [JikanAnime] = [] {
        didSet {
            saveWatchList()
        }
    }

    private let storageKey = "WATCHLIST"

    init() {
        loadWatchlist()
    }

    func add(_ anime: JikanAnime) {
        if !watchList.contains(where: { $0.malId == anime.malId }) {
            watchList.append(anime)
        }
    }

    func remove(_ anime: JikanAnime) {
        watchList.removeAll { $0.malId == anime.malId }
    }

    func isWatchListed(_ anime: JikanAnime) -> Bool {
        watchList.contains(where: { $0.malId == anime.malId })
    }

    func clearAll() {
        watchList.removeAll()
    }

    private func saveWatchList() {
        if let data = try? JSONEncoder().encode(watchList) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadWatchlist() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([JikanAnime].self, from: data) {
            self.watchList = saved
        }
    }
}
