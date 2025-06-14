//
//  Anime.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//
import Foundation

struct Anime: Codable, Identifiable {
    let id: Int
    let title: String
    let url: URL
    let imageURL: URL
    let synopsis: String?
    let type: String?
    let episodes: Int?
    let score: Double?
    let status: String?
    let startDate: String?
    let endDate: String?
    let members: Int?
    let duration: String?
    let rating: String?
    let genres: [Genre]?
}

struct Genre: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: URL
}
