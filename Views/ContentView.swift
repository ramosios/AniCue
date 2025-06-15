//
//  ContentView.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: CustomTabBarView.Tab = .discover

    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            Group {
                switch selectedTab {
                case .discover:
                    DiscoverView()
                case .watchlist:
                    WatchlistView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tab bar
            CustomTabBarView(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

