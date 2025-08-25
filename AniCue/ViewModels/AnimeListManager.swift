import Foundation
import RealmSwift

class AnimeListManager: ObservableObject {
    static let shared = AnimeListManager()
    private let realm: Realm

    @Published var watchlist: [JikanAnime] = []
    @Published var watched: [JikanAnime] = []
    @Published var downloaded: [JikanAnime] = []

    init() {
        do {
            realm = try Realm()
            refreshLists()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    func loadDownloadedAnimesFromJSON(from filename: String) throws {
           guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
               throw LocalLoaderError.fileNotFound(filename)
           }

           let data: Data
           do {
               data = try Data(contentsOf: url)
           } catch {
               throw LocalLoaderError.dataLoadingFailed(error)
           }

           do {
               let response = try JSONDecoder().decode(JikanAnimeListResponse.self, from: data)
               let realmAnimes = response.data.map { RealmAnime(from: $0, listType: .downloaded) }
               try realm.write {
                   realm.add(realmAnimes, update: .modified)
               }
               updateList(list: .downloaded)
           } catch {
               throw LocalLoaderError.decodingFailed(error)
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
