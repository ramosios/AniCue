import SwiftUI

struct ProfileBackgroundChangerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedBackground: String
    @State private var profileImage: UIImage?
    @State private var userName: String = "Username"
    @State private var watchedCount: Int = 0
    
    private let backgroundOptions = [
        "UpaniBackground_Image1",
        "UpaniBackground_Image2"
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init() {
        // Initialize state with the currently saved background or a default
        _selectedBackground = State(initialValue: UserDefaults.standard.string(forKey: UserDefaultKeys.profileBackgroundKey) ?? "UpaniBackground_Image2")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Preview Section
                Text("Preview")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ProfileHeaderView(
                    profileImage: $profileImage,
                    selectedItem: .constant(nil), // Not used for preview
                    userName: userName,
                    watchedCount: watchedCount,
                    background: selectedBackground
                )
                .padding(.horizontal)

                // MARK: - Selector Section
                Text("Choose a background")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(backgroundOptions, id: \.self) { imageName in
                        Button(action: {
                            self.selectedBackground = imageName
                            saveSelection(background: imageName)
                        }, label: {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedBackground == imageName ? Color.accentColor : Color.clear, lineWidth: 4)
                                )
                        })
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Change Background")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveSelection(background: String) {
        UserDefaults.standard.set(background, forKey: UserDefaultKeys.profileBackgroundKey)
    }
}

struct ProfileBackgroundChangerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileBackgroundChangerView()
        }
    }
}
