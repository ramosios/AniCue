//
//  AnimeListViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 22/06/25.
//
import Foundation

class AnimeListViewModel: ObservableObject {
    @Published private(set) var animes: [JikanAnime] = []

    private let filename: String

    init(filename: String) {
        self.filename = filename
        load()
    }

    func add(_ anime: JikanAnime) {
        guard !animes.contains(where: { $0.malId == anime.malId }) else { return }
        animes.append(anime)
        save()
    }

    func remove(_ anime: JikanAnime) {
        animes.removeAll { $0.malId == anime.malId }
        save()
    }

    func isAdded(_ anime: JikanAnime) -> Bool {
        animes.contains(where: { $0.malId == anime.malId })
    }

    func clearAll() {
        animes.removeAll()
        save()
    }

    private func save() {
        guard let url = getFileURL(),
              let data = try? JSONEncoder().encode(animes) else { return }
        try? data.write(to: url, options: .atomic)
    }

    private func load() {
        guard let url = getFileURL(),
              let data = try? Data(contentsOf: url),
              let saved = try? JSONDecoder().decode([JikanAnime].self, from: data) else {
            animes = []
            return
        }
        animes = saved
    }

    private func getFileURL() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent(filename)
    }
}
