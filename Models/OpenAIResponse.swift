//
//  OpenAIResponse.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//
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
