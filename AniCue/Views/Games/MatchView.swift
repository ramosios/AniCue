//
//  MatchView.swift
//  AniCue
//
//  Created by Jorge Ramos on 10/08/25.
//
import SwiftUI

struct MatchView: View {
    @State private var animes: [JikanAnime] = JikanAnime.sampleData

    private func removeTopCard() {
        if !animes.isEmpty {
            animes.removeFirst()
        }
    }

    private func superLike() {
        // Handle super like logic
        removeTopCard()
    }

    private func like() {
        // Handle like logic
        removeTopCard()
    }

    private func dislike() {
        // Handle dislike logic
        removeTopCard()
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
                    ForEach(animes.indices, id: \.self) { index in
                        let anime = animes[index]
                        CardView(anime: anime, onRemove: {
                            if index == 0 { // Ensure only the top card can be removed
                                removeTopCard()
                            }
                        })
                        .padding(.horizontal)
                        // Stack from back to front
                        .zIndex(Double(animes.count - 1 - index))
                        // Only allow the top card to be swiped
                        .allowsHitTesting(index == 0)
                    }
                }
            }
            .padding(.top, 20)

            Spacer()

            // Action Buttons
            HStack(spacing: 20) {
                // Swipe Left Button
                Button(action: dislike) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding()
                        .background(Circle().fill(Color.white).shadow(radius: 5))
                }

                // Super Like Button
                Button(action: superLike) {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Circle().fill(Color.white).shadow(radius: 5))
                }

                // Swipe Right Button
                Button(action: like) {
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding()
                        .background(Circle().fill(Color.white).shadow(radius: 5))
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("Find Your Match")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Sample data for previewing
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
