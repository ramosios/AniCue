//
//  ProfileView.swift
//  AniCue
//
//  Created by Jorge Ramos on 15/06/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var favorites: WatchListViewModel
    @EnvironmentObject var watched: WatchedViewModel
    @State private var showingConfirmReset = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 32) {
                        // Profile Header
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 96, height: 96)
                                .foregroundColor(.accentColor)

                            Text("AniCue User")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Watched \(watched.watched.count) anime titles")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)

                        // Navigation Items
                        VStack(spacing: 16) {
                            ProfileNavigationLink(title: "Watched Anime", icon: "eye.fill") {
                                WatchedAnimeView()
                            }

                            ProfileNavigationLink(title: "Preferences", icon: "slider.horizontal.3") {
                                UserPreferenceView()
                            }

                            Button(role: .destructive) {
                                showingConfirmReset = true
                            } label: {
                                Label("Clear All Data", systemImage: "trash")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                }

                if showingConfirmReset {
                    Color.black.opacity(0.4).ignoresSafeArea()

                    CustomAlert(
                        title: "Confirm Reset",
                        message: "Are you sure you want to clear all data?",
                        primaryAction: {
                            favorites.clearAll()
                            watched.clearAll()
                            showingConfirmReset = false
                        },
                        dismiss: {
                            showingConfirmReset = false
                        }
                    )
                    .zIndex(1)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationTitle("Profile")
            .animation(.easeInOut(duration: 0.3), value: showingConfirmReset)
        }
    }
}
