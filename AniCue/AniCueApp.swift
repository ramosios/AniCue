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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userPreferences)
        }
    }
}
