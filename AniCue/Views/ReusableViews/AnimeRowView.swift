//
//  AnimeRowView.swift
//  AniCue
//
//  Created by Jorge Ramos on 19/06/25.
//

import SwiftUI

struct AnimeRowView: View {
    let anime: JikanAnime
    let isFavorite: Bool
    let isWatched: Bool
    let onToggleFavorite: () -> Void
    let onMarkWatched: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            animeImage
            animeDetails
            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var animeImage: some View {
        let imageURLString = anime.images?["jpg"]?.imageUrl ??
                             anime.images?["jpg"]?.largeImageUrl ??
                             anime.images?["webp"]?.imageUrl ??
                             anime.images?["webp"]?.largeImageUrl

        return Group {
            if let url = imageURLString.flatMap(URL.init) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Color.gray.opacity(0.3)
                    }
                }
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .frame(width: 90, height: 130)
        .cornerRadius(12)
        .clipped()
    }

    private var animeDetails: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(anime.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)

            HStack(spacing: 8) {
                if let score = anime.score {
                    Label("\(String(format: "%.1f", score))", systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }

                if let episodes = anime.episodes {
                    Label("\(episodes)", systemImage: "play.rectangle")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let source = anime.source {
                    Label(source, systemImage: "sparkles")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }

            HStack(spacing: 14) {
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .padding(6)
                        .background(Circle().fill(isFavorite ? Color.red.opacity(0.15) : Color.gray.opacity(0.15)))
                }

                Button(action: onMarkWatched) {
                    HStack(spacing: 6) {
                        Image(systemName: isWatched ? "checkmark.circle.fill" : "eye")
                        Text(isWatched ? "Watched" : "Mark Watched")
                    }
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isWatched ? Color.green.opacity(0.8) : Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding(.top, 4)
        }
    }
}
