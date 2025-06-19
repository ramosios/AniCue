//
//  WatchedAnimeView.swift
//  AniCue
//
//  Created by Jorge Ramos on 16/06/25.
//
import SwiftUI
struct WatchedAnimeView: View {
    @EnvironmentObject var watched: WatchedViewModel

    var body: some View {
        NavigationView {
            if watched.watched.isEmpty {
                Text("You haven't added any anime to you´re watched list.")
                    .padding()
                    .navigationTitle("Watchlist")
            } else {
                AnimeListView(animes: watched.watched)
                .navigationTitle("Watched")
            }
        }
    }
}
