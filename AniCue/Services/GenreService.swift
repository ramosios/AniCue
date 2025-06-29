//
//  GenreService.swift
//  AniCue
//
//  Created by Jorge Ramos on 28/06/25.
//
import Foundation
class GenreService {
    static func loadGenreMap() -> [Int: String]? {
        guard let url = Bundle.main.url(forResource: "genres", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let rawMap = try? JSONDecoder().decode([String: String].self, from: data) else {
            return nil
        }
        return rawMap.compactMapKeys { Int($0) }
    }
}
extension Dictionary {
    func compactMapKeys<T>(_ transform: (Key) throws -> T?) rethrows -> [T: Value] {
        var result = [T: Value]()
        for (key, value) in self {
            if let newKey = try transform(key) {
                result[newKey] = value
            }
        }
        return result
    }
}
