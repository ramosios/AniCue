//
//  AppDelegate.swift
//  AniCue
//
//  Created by Jorge Ramos on 06/07/25.
//

import UIKit
import SwiftUICore
import OSLog

class AppDelegate: NSObject, UIApplicationDelegate {
    @ObservedObject var animeList = AnimeListManager.shared
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.unknown", category: "AppDelegate")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        loadGenresIfNeeded()
        loadDownloadedAnimesIfNeeded()
        return true
    }

    private func loadGenresIfNeeded() {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: UserDefaultKeys.genresKey) == nil {
            defaults.set(GenreService.loadGenreMap(), forKey: "genres")
        }
    }
    private func loadDownloadedAnimesIfNeeded() {
            if animeList.downloaded.isEmpty {
                let fileNames = ["top_1-400_animes.json", "top_401-800_animes.json", "top_801-1200_animes.json"]
                for fileName in fileNames {
                    do {
                        try animeList.loadDownloadedAnimesFromJSON(from: fileName)
                    } catch {
                        Self.logger.error("Failed to load downloaded animes from '\(fileName)': \(error.localizedDescription)")
                }
            }
        }
    }
}
