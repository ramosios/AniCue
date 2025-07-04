//
//  DiscoverView.swift
//  AniCue
//
//  Created by Jorge Ramos on 15/06/25.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @EnvironmentObject var userPreferences: UserPreferencesViewModel
    @EnvironmentObject var favorites: WatchListViewModel
    @EnvironmentObject var watched: WatchedViewModel
    @State private var prompt = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    PromptInputView(prompt: $prompt) {
                        Task {
                            await viewModel.formatDataApiCalls(for: prompt, preferences: userPreferences, favorites: favorites, watched: watched)
                        }
                    }

                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error)
                            .padding(.horizontal)
                    }

                    if viewModel.isLoading {
                        UpaniAnimation()
                            .padding(.top, 40)
                    } else if viewModel.noRecommendations {
                        Image("UpaniEmptyResults")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 240)
                            .padding(.top, 40)
                            .opacity(0.7)
                    } else {
                        AnimeListView(animes: viewModel.animes, source: .discover)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
