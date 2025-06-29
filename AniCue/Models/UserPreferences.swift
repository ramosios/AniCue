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

func formatUserPreference(from answers: [String]) -> (startDate: String?, endDate: String?, format: String?, popularity: String?) {
    guard answers.count >= 3 else {
        return (nil, nil, nil, nil)
    }

    let releasePref = answers[0].lowercased()
    let includeMovies = answers[1].lowercased()
    let visibilityPref = answers[2].lowercased()

    // Date range handling
    let dateRange: (String?, String?) = {
        switch releasePref {
        case "recent":
            return ("2023-01-01", "2025-04-01")
        case "2022-2010":
            return ("2010-01-01", "2022-12-31")
        case "2000s":
            return ("2000-01-01", "2009-12-31")
        case "1990s or earlier":
            return ("1990-01-01", "1999-12-31")
        default:
            return (nil, nil)
        }
    }()

    // Format type: if user says "No", return "TV"; if "Yes", return nil (include all)
    let normalizedFormat: String? = {
        switch includeMovies {
        case "no":
            return "tv"
        case "yes":
            return nil
        default:
            return nil
        }
    }()

    // Popularity category mapping
    let normalizedVisibility: String? = {
        switch visibilityPref {
        case "popular hits":
            return "popular"
        case "hidden gems":
            return "niche"
        case "niche":
            return "obscure"
        case "no preference":
            return nil
        default:
            return visibilityPref.lowercased()
        }
    }()

    return (dateRange.0, dateRange.1, normalizedFormat, normalizedVisibility)
}
