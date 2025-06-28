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
        case 1: return nil
        case 2: return "I prefer \(value)"
        default: return nil
        }
    }

    return transformed.isEmpty ? "" :
        "\nTake into account these preferences: " + transformed.joined(separator: ", ") + "."
}

func preferenceDates(from answers: [String]) -> (startDate: String?, endDate: String?) {
    guard let releasePref = answers.first?.lowercased() else {
        return (nil, nil)
    }

    switch releasePref {
    case "recent":
        return ("2023-01-01", nil)
    case "2022-2010":
        return ("2010-01-01", "2022-12-31")
    case "2000s":
        return ("2000-01-01", "2009-12-31")
    case "1990s":
        return ("1990-01-01", "1999-12-31")
    default:
        return (nil, nil)
    }
}

func preferenceIntensity(from answers: [String]) -> Double {
    guard answers.indices.contains(1) else { return 0.7}
    switch answers[1].lowercased() {
    case "objective": return 0.3
    case "moderate": return 0.7
    case "wild": return 0.9
    default: return 0.7
    }
}
