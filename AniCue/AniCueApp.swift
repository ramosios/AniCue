// AniCueApp.swift
import SwiftUI

@main
struct AniCueApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var favorites = WatchListViewModel()
    @StateObject var watched = WatchedViewModel()
    @State private var isShowingLaunchAnimation = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isShowingLaunchAnimation {
                    LaunchScreenView()
                } else {
                    ContentView()
                        .environmentObject(favorites)
                        .environmentObject(watched)
                        .accentColor(.teal)
                }
            }
            .onAppear {
                // Hide the launch animation after 1.2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    withAnimation {
                        isShowingLaunchAnimation = false
                    }
                }
            }
        }
    }
}
