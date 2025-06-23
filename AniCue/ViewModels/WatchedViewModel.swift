//
//  WatchedViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 19/06/25.
//
import Foundation

class WatchedViewModel: AnimeListViewModel {
    init() {
        super.init(filename: "watched_movies.json")
    }

    func markAsWatched(_ anime: JikanAnime) {
        add(anime)
    }

    func isWatched(_ anime: JikanAnime) -> Bool {
        isAdded(anime)
    }
}
