import Foundation
import RealmSwift

class AnimeListManager: ObservableObject {
    static let shared = AnimeListManager()
    private let realm: Realm

    @Published var watchlist: [JikanAnime] = []
    @Published var watched: [JikanAnime] = []

    init() {
        do {
            realm = try Realm()
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
        refreshLists()
    }

    func removeAnime(_ anime: JikanAnime) {
        objectWillChange.send()
        if let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) {
            try? realm.write {
                realm.delete(object)
            }
        }
        refreshLists()
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
    }
}
