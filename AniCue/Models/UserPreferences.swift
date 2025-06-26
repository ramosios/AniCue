//
//  UserPreferences.swift
//  AniCue
//
//  Created by Jorge Ramos on 16/06/25.
//
import Foundation

struct UserPreferences: Codable {
    var answers: [String]
}

func formatPreferences(_ preferences: [String]) -> String {
    let transformed: [String] = preferences.enumerated().compactMap { index, i in
        let value = i.lowercased()
        guard value != "no preference" else { return nil }

        switch index {
        case 0: return "I like \(value) animes"
        case 1: return "I usually watch animes \(value)"
        case 2: return "I prefer \(value)"
        default: return nil
        }
    }

    return transformed.isEmpty ? "" :
        "\nTake into account these preferences: " + transformed.joined(separator: ", ") + "."
}
