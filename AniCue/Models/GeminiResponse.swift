//
//  GeminiResponse.swift
//  AniCue
//
//  Created by Jorge Ramos on 24/07/25.
//
import Foundation

struct GeminiResponse: Codable {
    let candidates: [Candidate]
    let promptFeedback: PromptFeedback?
}

struct Candidate: Codable {
    let content: Content
    let finishReason: String?
    let index: Int
    let safetyRatings: [SafetyRating]
}

struct Content: Codable {
    let parts: [Part]
    let role: String
}

struct Part: Codable {
    let text: String
}

struct PromptFeedback: Codable {
    let safetyRatings: [SafetyRating]
}

struct SafetyRating: Codable {
    let category: String
    let probability: String
}

enum GeminiError: Error, LocalizedError, Equatable {
    case missingAPIKey
    case invalidResponse
    case decodingFailed
    case emptyCandidates
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "Missing Gemini API key."
        case .invalidResponse: return "Invalid response from Gemini."
        case .decodingFailed: return "Failed to decode Gemini response."
        case .emptyCandidates: return "No suggestions received."
        case .serverError(let message): return "Gemini server error: \(message)"
        }
    }
}
