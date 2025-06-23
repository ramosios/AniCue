//
//  WatchlistViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 19/06/25.
//
import Foundation

class WatchListViewModel: AnimeListViewModel {
    init() {
        super.init(filename: "watchlist.json")
    }

    func isWatchListed(_ anime: JikanAnime) -> Bool {
        isAdded(anime)
    }
}
