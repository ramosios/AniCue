//
//  AppDelegate.swift
//  AniCue
//
//  Created by Jorge Ramos on 06/07/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        loadGenresIfNeeded()
        return true
    }

    private func loadGenresIfNeeded() {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "genres") == nil {
            defaults.set(GenreService.loadGenreMap(), forKey: "genres")
        }
    }
}
