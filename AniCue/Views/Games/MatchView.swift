//
//  MatchView.swift
//  AniCue
//
//  Created by Jorge Ramos on 10/08/25.
//
import SwiftUI

struct MatchView: View {
    @State private var animes: [JikanAnime] = JikanAnime.sampleData
    @State private var cardOffsets: [Int: CGSize] = [:]

    private enum SwipeDirection {
        case left, right
    }

    private func removeCard(at index: Int) {
        guard index >= 0 && index < animes.count else { return }
        let animeId = animes[index].id
        animes.remove(at: index)
        cardOffsets.removeValue(forKey: animeId)
    }

    private func swipeCard(at index: Int, direction: SwipeDirection) {
        guard index >= 0 && index < animes.count else { return }
        let animeId = animes[index].id

        withAnimation(.spring()) {
            switch direction {
            case .left:
                cardOffsets[animeId] = CGSize(width: -500, height: 0)
            case .right:
                cardOffsets[animeId] = CGSize(width: 500, height: 0)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let firstIndex = animes.firstIndex(where: { $0.id == animeId }) {
                removeCard(at: firstIndex)
            }
        }
    }

    private func like() {
        swipeCard(at: 0, direction: .right)
    }

    private func dislike() {
        swipeCard(at: 0, direction: .left)
    }

    var body: some View {
        VStack {
            // Card Stack
            ZStack {
                if animes.isEmpty {
                    Text("No more anime!")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(Array(animes.enumerated().reversed()), id: \.element.id) { index, anime in
                        CardView(
                            anime: .constant(anime),
                            offset: Binding(
                                get: { cardOffsets[anime.id] ?? .zero },
                                set: { cardOffsets[anime.id] = $0 }
                            ),
                            onRemove: {
                                if let firstIndex = animes.firstIndex(where: { $0.id == anime.id }) {
                                    let direction: SwipeDirection = (cardOffsets[anime.id]?.width ?? 0) > 0 ? .right : .left
                                    swipeCard(at: firstIndex, direction: direction)
                                }
                            }
                        )
                        .allowsHitTesting(index == 0) // Only top card is interactive
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Action Buttons
            HStack(spacing: 40) {
                Button(action: dislike) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                        .padding()
                        .background(Circle().fill(Color.white).shadow(radius: 5))
                }
                Button(action: like) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.green)
                        .padding()
                        .background(Circle().fill(Color.white).shadow(radius: 5))
                }
            }
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
