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
    @Binding var userName: String
    @Binding var isEditingName: Bool
    @Binding var tempUserName: String
    let watchedCount: Int
    let userNameKey: String
    let profileImageKey: String
    let defaultUserName = "AniCueUser"

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
                                UserDefaults.standard.set(imageData, forKey: profileImageKey)
                            }
                        }
                    }
                }
            }

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
                        let trimmed = tempUserName.trimmingCharacters(in: .whitespacesAndNewlines)
                        userName = trimmed.isEmpty ? defaultUserName : trimmed
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
                        // If current name is default, clear the text field for editing
                        tempUserName = (userName == defaultUserName) ? "" : userName
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
