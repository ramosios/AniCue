import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @EnvironmentObject var userPreferences: UserPreferencesViewModel
    @EnvironmentObject var favorites: WatchListViewModel
    @EnvironmentObject var watched: WatchedViewModel
    @State private var prompt = ""
    @FocusState private var inputIsFocused: Bool

    private struct SuggestedPrompt: Identifiable {
        let id = UUID()
        let text: String
        let iconName: String
    }

    private let suggestedPrompts: [SuggestedPrompt] = [
        SuggestedPrompt(text: "Top 10 action anime from the 90s", iconName: "flame.fill"),
        SuggestedPrompt(text: "Suggest some psychological thrillers", iconName: "brain.head.profile"),
        SuggestedPrompt(text: "What are some good romance anime?", iconName: "heart.fill"),
        SuggestedPrompt(text: "I'm looking for a sci-fi series", iconName: "sparkles")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 16) {
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
                .onTapGesture {
                    inputIsFocused = false
                }
                .navigationBarTitleDisplayMode(.inline)

                if !viewModel.isLoading && viewModel.animes.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try one of these prompts")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(suggestedPrompts) { suggestion in
                                    Button(action: {
                                        prompt = suggestion.text
                                        sendPrompt()
                                    }, label: {
                                        HStack {
                                            Image(systemName: suggestion.iconName)
                                            Text(suggestion.text)
                                        }
                                        .font(.subheadline)
                                        .padding()
                                        .background(.thinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 8)
                }

                ChatInputBarView(
                    text: $prompt,
                    isFocused: $inputIsFocused,
                    action: sendPrompt
                )
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    private func sendPrompt() {
        guard !prompt.isEmpty else { return }
        let messageToSend = prompt
        prompt = ""
        inputIsFocused = false
        Task {
            await viewModel.formatDataApiCalls(
                for: messageToSend,
                preferences: userPreferences,
                favorites: favorites,
                watched: watched
            )
        }
    }
}
