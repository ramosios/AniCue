import SwiftUI

struct UserPreferenceView: View {
    @EnvironmentObject var viewModel: UserPreferencesViewModel

    private let questions = [
        ("Preferred anime length?", "clock"),
        ("Do you prefer new or old anime?", "calendar"),
        ("What type of anime do you enjoy?", "star")
    ]

    private let options: [[String]] = [
        ["11–13 episodes", "25–50 episodes", "50+ episodes", "No preference"],
        ["New", "Old", "No preference"],
        ["Popular", "Niche", "Obscure", "No preference"]
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(0..<questions.count, id: \.self) { qIndex in
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
                                    Button(action: {
                                        viewModel.selectedAnswers[qIndex] = answer
                                        viewModel.saveAnswers()
                                    }, label: {
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
                                    })
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
            }
            .navigationTitle("Your Preferences")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
