//
//  CardView.swift
//  AniCue
//
//  Created by Jorge Ramos on 10/08/25.
import SwiftUI

struct CardView: View {
    @Binding var anime: JikanAnime
    @Binding var offset: CGSize

    var onRemove: () -> Void

    var body: some View {
        ZStack {
            // Card Image and Background
            ZStack {
                AsyncImage(url: URL(string: anime.images?.jpg?.largeImageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray5)
                    ProgressView()
                }
                .frame(width: 400, height: 600)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)

                // Gradient Overlay for Text
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(anime.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            if let type = anime.type, let episodes = anime.episodes {
                                Text("\(type) • \(episodes) episodes")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.black.opacity(0.6), .clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
            }
            .frame(width: 400, height: 600)
            .cornerRadius(20)

            // Swipe indicator
            if offset.width > 0 {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(Double(offset.width / 100) - 0.2))
                Text("LIKE")
                    .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    .padding(4).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 4))
            } else if offset.width < 0 {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.red.opacity(Double(abs(offset.width) / 100) - 0.2))
                Text("NOPE")
                    .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    .padding(4).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 4))
            }
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    withAnimation(.spring()) {
                        if abs(gesture.translation.width) > 100 {
                            onRemove()
                        } else {
                            offset = .zero
                        }
                    }
                }
        )
    }
}
