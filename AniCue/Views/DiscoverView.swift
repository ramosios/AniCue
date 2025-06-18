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
    @State private var prompt = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    PromptInputView(prompt: $prompt) {
                        Task {
                            let preferences = userPreferences.selectedAnswers
                            await viewModel.getRecommendations(for: prompt, userPreferences: preferences, avoiding: [])
                        }
                    }

                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error)
                            .padding(.horizontal)
                    }

                    if viewModel.isLoading {
                        LoadingView()
                            .padding(.top, 40)
                    } else {
                        AnimeListView(animes: viewModel.animes)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
