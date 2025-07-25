import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var animeList = AnimeListManager.shared
    @State private var showingConfirmReset = false

    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var userName: String = "Upani User"
    @AppStorage(UserDefaultKeys.profileBackgroundKey) private var selectedBackground: String = "UpaniBackground_Image1"

    init() {
        if let savedName = UserDefaults.standard.string(forKey: UserDefaultKeys.userNameKey) {
            _userName = State(initialValue: savedName)
        }
        if let imageData = UserDefaults.standard.data(forKey: UserDefaultKeys.profileImageKey),
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
                            watchedCount: animeList.watched.count,
                            background: selectedBackground
                        )

                        VStack(spacing: 16) {
                            ProfileNavigationLink(title: "Watched Anime", icon: "eye.fill") {
                                WatchedAnimeView()
                            }
                            ProfileNavigationLink(title: "Discover Preferences", icon: "slider.horizontal.3") {
                                UserPreferenceView()
                            }
                            ProfileNavigationLink(title: "Change Background Image", icon: "photo.on.rectangle.angled") {
                                ProfileBackgroundChangerView(selectedBackground: $selectedBackground, profileImage: profileImage, userName: userName, watchedCount: animeList.watched.count)
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
                            animeList.deleteAll()
                            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userNameKey)
                            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.profileImageKey)
                            userName = "AniCue User"
                            profileImage = nil
                            selectedBackground = "UpaniBackground_Image1" // Reset to default
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
            if let savedName = UserDefaults.standard.string(forKey: UserDefaultKeys.userNameKey) {
                userName = savedName
            }
            if let imageData = UserDefaults.standard.data(forKey: UserDefaultKeys.profileImageKey),
               let image = UIImage(data: imageData) {
                profileImage = image
            }
        }
    }
}
