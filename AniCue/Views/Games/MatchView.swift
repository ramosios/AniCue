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
