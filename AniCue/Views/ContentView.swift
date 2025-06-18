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
        TabView(selection: $selectedTab) {
            DiscoverView()
                .tag(CustomTabBarView.Tab.discover)
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }

            WatchlistView()
                .tag(CustomTabBarView.Tab.watchlist)
                .tabItem {
                    Label("Watchlist", systemImage: "bookmark")
                }

            ProfileView()
                .tag(CustomTabBarView.Tab.profile)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
