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
            Group {
                if watchList.animes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("Your watchlist is empty.")
                            .font(.headline)
                        Text("Add some anime to get started!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                } else {
                    AnimeListView(animes: watchList.animes)
                }
            }
            .navigationTitle("Watchlist")
        }
    }
}
