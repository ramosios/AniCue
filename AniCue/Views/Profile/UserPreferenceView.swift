import SwiftUI

struct UserPreferenceView: View {
    @EnvironmentObject var viewModel: UserPreferencesViewModel
    @State private var showingHelpIndex: Int?

    private let questions = [
        ("Which release period are you looking for in anime?", "calendar"),
        ("Should Movies and OVAs be included in your results?", "magnifyingglass"),
        ("What type of anime are you looking to explore?", "star")
    ]

    private let options: [[String]] = [
        ["Recent", "2022-2010", "2000s", "1990s or earlier", "No preference"],
        ["Yes", "No"],
        ["Popular Hits", "Hidden Gems", "Niche", "No preference"]
    ]

    private let explanations = [
        "Select the time period of anime releases you are interested in.",
        "Choose whether to include Movies and OVAs in your search results.",
        "Pick the type of anime you want to discover."
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(0..<questions.count, id: \.self) { qIndex in
                        ZStack(alignment: .topTrailing) {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 12) {
                                    Image(systemName: questions[qIndex].1)
                                        .font(.title2)
                                        .foregroundColor(.accentColor)

                                    Text(questions[qIndex].0)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }

                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
                                    ForEach(options[qIndex], id: \.self) { answer in
                                        Button(
                                            action: {
                                                viewModel.selectedAnswers[qIndex] = answer
                                                viewModel.saveAnswers()
                                            },
                                            label: {
                                                Text(answer)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 10)
                                                    .frame(maxWidth: .infinity)
                                                    .background(
                                                        viewModel.selectedAnswers[qIndex] == answer
                                                        ? Color.accentColor
                                                        : Color(.systemGray6)
                                                    )
                                                    .foregroundColor(
                                                        viewModel.selectedAnswers[qIndex] == answer
                                                        ? .white
                                                        : .primary
                                                    )
                                                    .clipShape(Capsule())
                                                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                                            }
                                        )
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)

                            // Info icon and info box overlay
                            VStack(alignment: .trailing, spacing: 4) {
                                Button(
                                    action: {
                                        if showingHelpIndex == qIndex {
                                            showingHelpIndex = nil
                                        } else {
                                            showingHelpIndex = qIndex
                                        }
                                    },
                                    label: {
                                        Image(systemName: "questionmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(10)
                                    }
                                )
                                .zIndex(2)

                                if showingHelpIndex == qIndex {
                                    Text(explanations[qIndex])
                                        .font(.callout)
                                        .foregroundColor(.primary)
                                        .padding(10)
                                        .background(Color(.systemBackground))
                                        .cornerRadius(10)
                                        .shadow(radius: 4)
                                        .frame(maxWidth: 220, alignment: .trailing)
                                        .transition(.opacity)
                                        .zIndex(1)
                                }
                            }
                        }
                        // Overlay for dismissing help
                        .overlay(
                            Group {
                                if showingHelpIndex == qIndex {
                                    Color.black.opacity(0.001)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            showingHelpIndex = nil
                                        }
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Your Preferences")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
