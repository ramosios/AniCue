import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var favorites: WatchListViewModel
    @EnvironmentObject var watched: WatchedViewModel
    @State private var showingConfirmReset = false

    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var userName: String = "Upani User"

    private let userNameKey = "profileUserName"
    private let profileImageKey = "profileImageData"

    init() {
        if let savedName = UserDefaults.standard.string(forKey: userNameKey) {
            _userName = State(initialValue: savedName)
        }
        if let imageData = UserDefaults.standard.data(forKey: profileImageKey),
           let image = UIImage(data: imageData) {
            _profileImage = State(initialValue: image)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 32) {
                        ProfileHeaderView(
                            profileImage: $profileImage,
                            selectedItem: $selectedItem,
                            userName: userName,
                            watchedCount: watched.animes.count,
                            profileImageKey: profileImageKey,
                            userNameKey: userNameKey
                        )

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
                            UserDefaults.standard.removeObject(forKey: userNameKey)
                            UserDefaults.standard.removeObject(forKey: profileImageKey)
                            userName = "AniCue User"
                            profileImage = nil
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
        .onAppear {
            if let savedName = UserDefaults.standard.string(forKey: userNameKey) {
                userName = savedName
            }
            if let imageData = UserDefaults.standard.data(forKey: profileImageKey),
               let image = UIImage(data: imageData) {
                profileImage = image
            }
        }
    }
}
