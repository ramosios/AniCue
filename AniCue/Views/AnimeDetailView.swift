//
//  AnimeDetailView.swift
//  AniCue
//
//  Created by Jorge Ramos on 18/06/25.
//
import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: anime.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                        .shadow(radius: 5)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 250)
                }

                Text(anime.title)
                    .font(.title)
                    .bold()
                    .padding(.top, 4)

                if let synopsis = anime.synopsis {
                    Text(synopsis)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Divider()

                Group {
                    if let score = anime.score {
                        Label("Score: \(String(format: "%.1f", score))", systemImage: "star.fill")
                    }

                    if let episodes = anime.episodes {
                        Label("Episodes: \(episodes)", systemImage: "film")
                    }

                    if let type = anime.type {
                        Label("Type: \(type)", systemImage: "tv")
                    }

                    if let rating = anime.rating {
                        Label("Rating: \(rating)", systemImage: "person.crop.circle.badge.exclamationmark")
                    }

                    if let status = anime.status {
                        Label("Status: \(status)", systemImage: "waveform.path.ecg")
                    }

                    if let duration = anime.duration {
                        Label("Duration: \(duration)", systemImage: "clock")
                    }

                    if let start = anime.startDate {
                        Label("Started: \(start)", systemImage: "calendar")
                    }

                    if let end = anime.endDate {
                        Label("Ended: \(end)", systemImage: "calendar.badge.clock")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                if let genres = anime.genres, !genres.isEmpty {
                    Text("Genres")
                        .font(.headline)
                        .padding(.top)

                    FlowLayout(alignment: .leading, spacing: 8) {
                        ForEach(genres, id: \.malID) { genre in
                            Text(genre.name)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FlowLayout<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let content: () -> Content

    init(alignment: HorizontalAlignment = .leading, spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
}
