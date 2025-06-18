import SwiftUI

struct AnimeListView: View {
    let animes: [JikanAnime]
    var onSelect: ((JikanAnime) -> Void)?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(animes, id: \.malId) { anime in
                    Button(action: {
                        onSelect?(anime)
                    }) {
                        HStack(alignment: .top, spacing: 12) {
                            AsyncImage(url: anime.images?["jpg"]?.imageUrl.flatMap(URL.init)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 90, height: 130)
                            .cornerRadius(12)
                            .clipped()

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
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}
