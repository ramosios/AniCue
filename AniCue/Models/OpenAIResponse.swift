//
//  OpenAIResponse.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//
import Foundation
struct OpenAIResponse: Codable {
    let choices: [Choice]
    struct Choice: Codable {
        let message: Message
    }
    struct Message: Codable {
        let role: String
        let content: String
    }
}
enum OpenAIError: Error, LocalizedError , Equatable {
    case missingAPIKey
    case invalidResponse
    case decodingFailed
    case emptyChoices
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "Missing OpenAI API key."
        case .invalidResponse: return "Invalid response from OpenAI."
        case .decodingFailed: return "Failed to decode OpenAI response."
        case .emptyChoices: return "No suggestions received."
        case .serverError(let message): return "OpenAI server error: \(message)"
        }
    }
}
