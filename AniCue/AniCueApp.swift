// AniCueApp.swift
import SwiftUI

@main
struct AniCueApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isShowingLaunchAnimation = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isShowingLaunchAnimation {
                    LaunchScreenView()
                } else {
                    ContentView()
                        .accentColor(.teal)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    withAnimation {
                        isShowingLaunchAnimation = false
                    }
                }
            }
        }
    }
}
