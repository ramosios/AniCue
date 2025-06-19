//
//  AnimeRowView.swift
//  AniCue
//
//  Created by Jorge Ramos on 19/06/25.
//

import Foundation
import SwiftUI

struct AnimeRowView: View {
    let anime: JikanAnime
    let isFavorite: Bool
    let isWatched: Bool
    let onToggleFavorite: () -> Void
    let onMarkWatched: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            let imageURLString = anime.images?["jpg"]?.imageUrl ??
                                 anime.images?["jpg"]?.largeImageUrl ??
                                 anime.images?["webp"]?.imageUrl ??
                                 anime.images?["webp"]?.largeImageUrl

            if let url = imageURLString.flatMap(URL.init) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(width: 90, height: 130)
                .cornerRadius(12)
                .clipped()
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 90, height: 130)
                    .cornerRadius(12)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(anime.title)
                    .font(.title3.bold())
                    .lineLimit(2)

                if let score = anime.score {
                    Label("\(String(format: "%.1f", score))", systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }

                if let episodes = anime.episodes {
                    Label("\(episodes) episodes", systemImage: "film")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let source = anime.source {
                    Label(source, systemImage: "person.crop.circle.badge.exclamationmark")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }

                HStack(spacing: 12) {
                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Button(action: onMarkWatched) {
                        Text(isWatched ? "✅ Watched" : "Mark Watched")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(isWatched ? Color.green.opacity(0.8) : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
    }
}
