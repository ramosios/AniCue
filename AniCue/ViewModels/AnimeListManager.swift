import Foundation
import RealmSwift

class AnimeListManager: ObservableObject {
    static let shared = AnimeListManager()
    private let realm: Realm

    @Published var watchlist: [JikanAnime] = []
    @Published var watched: [JikanAnime] = []
    @Published var downloaded: [JikanAnime] = []

    init() {
        guard let defaultRealmURL = Realm.Configuration.defaultConfiguration.fileURL else {
                fatalError("Could not get default Realm file URL.")
            }
        let isFirstLaunch = !FileManager.default.fileExists(atPath: defaultRealmURL.path)

        if isFirstLaunch {
            if let bundledRealmURL = Bundle.main.url(forResource: "PreloadedAnimes", withExtension: "realm") {
            do {
                try FileManager.default.copyItem(at: bundledRealmURL, to: defaultRealmURL)
                } catch {
                    fatalError("Failed to copy preloaded Realm file: \(error)")
                    }
                }
            }

            do {
                realm = try Realm()

                if isFirstLaunch {
                    // On first launch, ensure all preloaded animes are in the downloaded list.
                    let allAnimes = realm.objects(RealmAnime.self)
                    try realm.write {
                        for anime in allAnimes {
                            anime.listType = .downloaded
                        }
                    }
                }

                refreshLists()
            } catch {
                fatalError("Failed to initialize Realm: \(error)")
            }
        }

    func addOrUpdateAnime(_ anime: JikanAnime, listType: AnimeListType) {
        objectWillChange.send()
        if let existing = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) {
            try? realm.write {
                existing.listType = listType
            }
        } else {
            let realmAnime = RealmAnime(from: anime, listType: listType)
            try? realm.write {
                realm.add(realmAnime)
            }
        }
        updateList(list: listType)
    }

    func removeAnime(_ anime: JikanAnime) {
        objectWillChange.send()
        if let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) {
            try? realm.write {
                realm.delete(object)
            }
        }
        updateList(list: .watched)
    }

    func deleteAll() {
        objectWillChange.send()
        let allAnimes = realm.objects(RealmAnime.self)
        try? realm.write {
            realm.delete(allAnimes)
        }
        refreshLists()
    }

    func getAnimes(for listType: AnimeListType) -> [JikanAnime] {
        let objects = realm.objects(RealmAnime.self).filter("listType == %@", listType)
        return objects.map { $0.toJikanAnime() }
    }

    func isAnimeInList(_ anime: JikanAnime, listType: AnimeListType) -> Bool {
        guard let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) else { return false }
        return object.listType == listType
    }

    private func refreshLists() {
        watchlist = getAnimes(for: .watchlist)
        watched = getAnimes(for: .watched)
        downloaded = getAnimes(for: .downloaded)
    }
    private func updateList(list: AnimeListType) {
        if list == .downloaded {
            downloaded = getAnimes(for: list)
        } else {
            watched = getAnimes(for: list)
            watchlist = getAnimes(for: list)
        }
    }
}
enum LocalLoaderError: Error, LocalizedError {
    case fileNotFound(String)
    case dataLoadingFailed(Error)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "The file '\(filename).json' was not found in the app bundle."
        case .dataLoadingFailed(let error):
            return "Failed to load data from the file: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode the JSON data: \(error.localizedDescription)"
        }
    }
}
