//
//  WatchlistView.swift
//  AniCue
//
//  Created by Jorge Ramos on 15/06/25.
//
import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var watchList: WatchListViewModel

    var body: some View {
        NavigationView {
            if watchList.watchList.isEmpty {
                Text("You haven't added any anime to you watchlist.")
                    .padding()
                    .navigationTitle("Watchlist")
            } else {
                AnimeListView(animes: watchList.watchList)
                .navigationTitle("Watchlist")
            }
        }
    }
}
