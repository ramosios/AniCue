//
//  AnimeListManager.swift
//  AniCue
//
//  Created by Jorge Ramos on 15/07/25.
//
import Foundation
import RealmSwift

class AnimeListManager: ObservableObject {
    private let realm: Realm

    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    func addOrUpdateAnime(_ anime: JikanAnime, listType: AnimeListType) {
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
    }

    func getAnimes(for listType: AnimeListType) -> [JikanAnime] {
        let objects = realm.objects(RealmAnime.self).filter("listType == %@", listType)
        return objects.map { $0.toJikanAnime() }
    }

    func isAnimeInList(_ anime: JikanAnime, listType: AnimeListType) -> Bool {
        guard let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) else { return false }
        return object.listType == listType
    }

    func removeAnime(_ anime: JikanAnime) {
        if let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) {
            try? realm.write {
                realm.delete(object)
            }
        }
    }
    
    func deleteAll() {
        let allAnimes = realm.objects(RealmAnime.self)
        try? realm.write {
            realm.delete(allAnimes)
        }
    }
}
