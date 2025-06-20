import SwiftUI

struct AnimeDetailView: View {
    let anime: JikanAnime

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrlString = anime.images?["jpg"]?.largeImageUrl,
                   let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                Text(anime.title)
                    .font(.title)
                    .bold()

                if let titleJapanese = anime.titleJapanese, !titleJapanese.isEmpty {
                    Text("Japanese: \(titleJapanese)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let synopsis = anime.synopsis, !synopsis.isEmpty {
                    Text(synopsis)
                        .font(.body)
                }

                Group {
                    if let score = anime.score {
                        Text("Score: \(String(format: "%.2f", score))")
                    }
                    if let rank = anime.rank {
                        Text("Rank: #\(rank)")
                    }
                    if let popularity = anime.popularity {
                        Text("Popularity: #\(popularity)")
                    }
                    if let episodes = anime.episodes {
                        Text("Episodes: \(episodes)")
                    }
                    if let duration = anime.duration, !duration.isEmpty {
                        Text("Duration: \(duration)")
                    }
                    if let status = anime.status, !status.isEmpty {
                        Text("Status: \(status)")
                    }
                }
                .font(.callout)
                .foregroundColor(.gray)

                if let genres = anime.genres, !genres.isEmpty {
                    Text("Genres: \(genres.map(\.name).joined(separator: ", "))")
                }

                if let streaming = anime.streaming, !streaming.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Available on:")
                            .bold()
                        ForEach(streaming, id: \.url) { platform in
                            if let url = URL(string: platform.url) {
                                Link(platform.name, destination: url)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Anime Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
