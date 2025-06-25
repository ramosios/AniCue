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
                        Image(systemName: "eye.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("Your watched list is empty.")
                            .font(.headline)
                        Text("Start watching anime to fill this list!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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
