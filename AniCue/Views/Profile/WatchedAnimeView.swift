//
//  WatchedAnimeView.swift
//  AniCue
//
//  Created by Jorge Ramos on 16/06/25.
//
import SwiftUI

struct WatchedAnimeView: View {
    @ObservedObject var animeList = AnimeListManager.shared

    var body: some View {
        NavigationView {
            Group {
                if animeList.watched.isEmpty {
                    VStack(spacing: 16) {
                        Image("UpaniWatched")
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                } else {
                    AnimeListView(animes: animeList.watched, source: .watched)
                }
            }
            .navigationTitle("Watched")
        }
    }
}
