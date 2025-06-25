//
//  ServiceProtocols.swift
//  AniCue
//
//  Created by Jorge Ramos on 25/06/25.
//
import Foundation

protocol OpenAIServiceProtocol {
    func fetchAnimeTitles(prompt: String, userPreferences: [String], excluding moviesToAvoid: [JikanAnime]) async throws -> [String]
}

protocol JikanServiceProtocol {
    func fetchAnimes(for titles: [String]) async throws -> [JikanAnime]
}
