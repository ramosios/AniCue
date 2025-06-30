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
                        Image("UpaniWatchlist")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                } else {
                    AnimeListView(animes: watchList.animes, source: .watchlist)
                }
            }
            .navigationTitle("Watchlist")
        }
    }
}
