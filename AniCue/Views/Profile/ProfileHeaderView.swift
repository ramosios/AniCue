//
//  ProfileHeaderView.swift
//  AniCue
//
//  Created by Jorge Ramos on 29/06/25.
//
import SwiftUI
import PhotosUI

struct ProfileHeaderView: View {
    @Binding var profileImage: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    let userName: String
    let watchedCount: Int

    var body: some View {
        VStack(spacing: 16) {
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
                                UserDefaults.standard.set(imageData, forKey: UserDefaultKeys.profileImageKey)
                            }
                        }
                    }
                }
            }

            Text(userName)
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: 200)
                .multilineTextAlignment(.center)

            Text("Watched \(watchedCount) anime titles")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}
