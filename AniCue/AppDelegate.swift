//
//  AppDelegate.swift
//  AniCue
//
//  Created by Jorge Ramos on 06/07/25.
//

import UIKit
import SwiftUICore

class AppDelegate: NSObject, UIApplicationDelegate {
    @ObservedObject var animeList = AnimeListManager.shared
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
            do {
                try animeList.loadDownloadedAnimesFromJSON(from: "Page1")
            } catch {
                    print("Failed to load downloaded animes: \(error)")
                }
            }
        }
}
