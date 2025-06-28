//
//  ServiceProtocols.swift
//  AniCue
//
//  Created by Jorge Ramos on 25/06/25.
//
import Foundation

protocol OpenAIServiceProtocol {
    func fetchAnimeTitles(prompt: String, userPreferences: [String], excluding moviesToAvoid: [Int]) async throws -> [String]
    func fetchGenres(from prompt: String) async throws -> [Int]
    func recommendTopAnime(from animes: [JikanAnime], prompt: String) async throws -> [JikanAnime]
}

protocol JikanServiceProtocol {
    func fetchAnimes(for titles: [String]) async throws -> [JikanAnime]
    func fetchFilteredAnime(
            genreIds: [Int],
            excludedMalIds: [Int],
            startDate: String,
            endDate: String,
            limit: Int,
            page: Int,
            minimumScore: Double
        ) async throws -> [JikanAnime]
}
