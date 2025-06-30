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
            Group {
                if watched.animes.isEmpty {
                    VStack(spacing: 16) {
                        Image("UpaniWatched")
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                } else {
                    AnimeListView(animes: watched.animes, source: .watched)
                }
            }
            .navigationTitle("Watched")
        }
    }
}
