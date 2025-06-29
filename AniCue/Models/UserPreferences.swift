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
