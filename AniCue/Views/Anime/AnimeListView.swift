import SwiftUI

struct AnimeListView: View {
    @EnvironmentObject var favorites: WatchListViewModel
    @EnvironmentObject var watched: WatchedViewModel

    let animes: [JikanAnime]
    let source: AnimeListSource

    var title: String {
        switch source {
        case .watchlist: return "Watchlist"
        case .watched: return "Watched"
        case .discover: return ""
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(animes, id: \.malId) { anime in
                    let isFavorite = favorites.isWatchListed(anime)
                    let isWatched = watched.isWatched(anime)

                    NavigationLink(destination: AnimeDetailView(anime: anime)) {
                        AnimeRowView(
                            anime: anime,
                            isFavorite: isFavorite,
                            isWatched: isWatched,
                            onToggleFavorite: {
                                withAnimation {
                                    if isFavorite {
                                        favorites.remove(anime)
                                    } else {
                                        favorites.add(anime)
                                        watched.remove(anime)
                                    }
                                }
                            },
                            onMarkWatched: {
                                withAnimation {
                                    if isWatched {
                                        watched.remove(anime)
                                    } else {
                                        watched.markAsWatched(anime)
                                        favorites.remove(anime)
                                    }
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}
enum AnimeListSource {
    case watchlist
    case watched
    case discover
}
