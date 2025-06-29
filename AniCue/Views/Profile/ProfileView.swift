import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var favorites: WatchListViewModel
    @EnvironmentObject var watched: WatchedViewModel
    @State private var showingConfirmReset = false

    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var userName: String = "AniCue User"
    @State private var isEditingName: Bool = false
    @State private var tempUserName: String = ""

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
                        VStack(spacing: 16) {
                            // Centered profile image
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 96, height: 96)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 96, height: 96)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .onChange(of: selectedItem) { _, newItem in
                                if let newItem {
                                    Task {
                                        if let data = try? await newItem.loadTransferable(type: Data.self),
                                           let uiImage = UIImage(data: data) {
                                            profileImage = uiImage
                                            if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                                                UserDefaults.standard.set(imageData, forKey: profileImageKey)
                                            }
                                        }
                                    }
                                }
                            }

                            // Name and edit/check button overlayed for symmetry
                            ZStack(alignment: .trailing) {
                                if isEditingName {
                                    TextField("Enter your name", text: $tempUserName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 200)
                                        .onChange(of: tempUserName) { _, newValue in
                                            if newValue.count > 10 {
                                                tempUserName = String(newValue.prefix(10))
                                            }
                                        }
                                    Button {
                                        userName = tempUserName
                                        UserDefaults.standard.set(userName, forKey: userNameKey)
                                        isEditingName = false
                                    } label: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.accentColor)
                                            .font(.title2)
                                    }
                                    .offset(x: 16)
                                } else {
                                    Text(userName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .frame(width: 200)
                                        .multilineTextAlignment(.center)
                                    Button {
                                        tempUserName = userName
                                        isEditingName = true
                                    } label: {
                                        Image(systemName: "pencil.circle.fill")
                                            .foregroundColor(.accentColor)
                                            .font(.title2)
                                    }
                                    .offset(x: 16)
                                }
                            }
                            .frame(width: 230, alignment: .center)

                            Text("Watched \(watched.animes.count) anime titles")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)

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
