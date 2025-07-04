//
//  UserPreferencesViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 16/06/25.
//
import Foundation

class UserPreferencesViewModel: ObservableObject {
    @Published var selectedAnswers: [String] = ["", "", ""] {
        didSet {
            saveAnswers()
        }
    }
    // Computed property for slider binding
    var minimumScore: Double {
        get { Double(selectedAnswers[2]) ?? 7 }
        set { selectedAnswers[2] = String(format: "%g", newValue) }
    }
    private let fileName = "user_preferences.json"

    // Allow tests to override the file path
    var overrideFileURL: URL?

    init(useInitialLoad: Bool = true) {
        if useInitialLoad {
            loadAnswers()
        }
    }

    func saveAnswers() {
        let preferences = UserPreferences(answers: selectedAnswers)
        if let data = try? JSONEncoder().encode(preferences),
           let url = getFileURL() {
            try? data.write(to: url)
        }
    }

    func loadAnswers() {
        guard let url = getFileURL(),
              let data = try? Data(contentsOf: url),
              let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            return
        }
        selectedAnswers = preferences.answers
    }

    private func getFileURL() -> URL? {
        overrideFileURL ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
}
