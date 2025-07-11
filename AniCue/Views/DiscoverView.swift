import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @EnvironmentObject var userPreferences: UserPreferencesViewModel
    @EnvironmentObject var favorites: WatchListViewModel
    @EnvironmentObject var watched: WatchedViewModel
    @State private var prompt = ""
    @FocusState private var inputIsFocused: Bool

    var body: some View {
        NavigationView {
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
                    .padding()
                }
                .onTapGesture {
                    inputIsFocused = false
                }

                ChatInputBar(
                    text: $prompt,
                    isFocused: $inputIsFocused,
                    action: sendPrompt
                )
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.regularMaterial)
                .clipShape(Capsule())
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
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

struct ChatInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    var action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField("Type your message…", text: $text)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .focused(isFocused)
                .onSubmit(action)

            Button(action: action) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
                    .foregroundColor(text.isEmpty ? .gray : .accentColor)
            }
            .disabled(text.isEmpty)
        }
    }
}
