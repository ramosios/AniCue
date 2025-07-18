//
//  WatchlistView.swift
//  AniCue
//
//  Created by Jorge Ramos on 15/06/25.
//
import SwiftUI

struct WatchlistView: View {
    @ObservedObject var animeList = AnimeListManager.shared

    var body: some View {
        NavigationView {
            Group {
                if animeList.watchlist.isEmpty {
                    VStack(spacing: 16) {
                        Image("UpaniWatchlist")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                } else {
                    AnimeListView(animes: animeList.watchlist, source: .watchlist)
                }
            }
            .navigationTitle("Watchlist")
        }
    }
}
