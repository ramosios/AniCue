//
//  MatchView.swift
//  AniCue
//
//  Created by Jorge Ramos on 10/08/25.
//
import SwiftUI

struct MatchView: View {
    @StateObject private var viewModel = MatchViewModel()

    var body: some View {
        VStack {
            // Card Stack
            ZStack {
                if viewModel.animes.isEmpty {
                    Text("No more anime!")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(Array(viewModel.animes.enumerated().reversed()), id: \.element.id) { index, anime in
                        CardView(
                            anime: .constant(anime),
                            offset: Binding(
                                get: { viewModel.cardOffsets[anime.id] ?? .zero },
                                set: { viewModel.cardOffsets[anime.id] = $0 }
                            ),
                            onRemove: {
                                viewModel.swipeCard(for: anime)
                            }
                        )
                        .allowsHitTesting(index == 0) // Only top card is interactive
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical)
        }
        .padding(.horizontal)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Find Your Match")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Sample data and Preview remain the same
extension JikanAnime {
    static var sampleData: [JikanAnime] {
        [
            JikanAnime(malId: 21, title: "One Piece", titleEnglish: nil, titleJapanese: nil, titleSynonyms: nil, synopsis: nil, type: "TV", episodes: 1072, duration: nil, status: nil, score: nil, rank: nil, popularity: nil, members: nil, favorites: nil, images: JikanImageFormats(jpg: JikanImage(imageUrl: nil, largeImageUrl: "https://cdn.myanimelist.net/images/anime/1244/138851l.jpg", smallImageUrl: nil), webp: nil), trailer: nil, aired: nil, studios: nil, producers: nil, licensors: nil, genres: nil, themes: nil, demographics: nil, source: nil, broadcast: nil, streaming: nil),
            JikanAnime(malId: 20, title: "Naruto", titleEnglish: nil, titleJapanese: nil, titleSynonyms: nil, synopsis: nil, type: "TV", episodes: 220, duration: nil, status: nil, score: nil, rank: nil, popularity: nil, members: nil, favorites: nil, images: JikanImageFormats(jpg: JikanImage(imageUrl: nil, largeImageUrl: "https://cdn.myanimelist.net/images/anime/13/17405l.jpg", smallImageUrl: nil), webp: nil), trailer: nil, aired: nil, studios: nil, producers: nil, licensors: nil, genres: nil, themes: nil, demographics: nil, source: nil, broadcast: nil, streaming: nil),
            JikanAnime(malId: 16498, title: "Attack on Titan", titleEnglish: nil, titleJapanese: nil, titleSynonyms: nil, synopsis: nil, type: "TV", episodes: 25, duration: nil, status: nil, score: nil, rank: nil, popularity: nil, members: nil, favorites: nil, images: JikanImageFormats(jpg: JikanImage(imageUrl: nil, largeImageUrl: "https://cdn.myanimelist.net/images/anime/10/47347l.jpg", smallImageUrl: nil), webp: nil), trailer: nil, aired: nil, studios: nil, producers: nil, licensors: nil, genres: nil, themes: nil, demographics: nil, source: nil, broadcast: nil, streaming: nil),
            JikanAnime(malId: 269, title: "Bleach", titleEnglish: nil, titleJapanese: nil, titleSynonyms: nil, synopsis: nil, type: "TV", episodes: 366, duration: nil, status: nil, score: nil, rank: nil, popularity: nil, members: nil, favorites: nil, images: JikanImageFormats(jpg: JikanImage(imageUrl: nil, largeImageUrl: "https://cdn.myanimelist.net/images/anime/3/40451l.jpg", smallImageUrl: nil), webp: nil), trailer: nil, aired: nil, studios: nil, producers: nil, licensors: nil, genres: nil, themes: nil, demographics: nil, source: nil, broadcast: nil, streaming: nil)
        ]
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MatchView()
        }
    }
}
