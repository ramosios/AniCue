//
//  AniCueApp.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//

import SwiftUI

@main
struct AniCueApp: App {
    @StateObject private var userPreferences = UserPreferencesViewModel()
    @StateObject var favorites = WatchListViewModel()
    @StateObject var watched = WatchedViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userPreferences)
                .environmentObject(favorites)
                .environmentObject(watched)
        }
    }
}
