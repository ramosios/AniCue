//
//  UserPromptView.swift
//  AniCue
//
//  Created by Jorge Ramos on 13/07/25.
//
import SwiftUI

struct UserPromptView: View {
    let prompt: String
    let profileImage: UIImage?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .font(.title3)
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }

            Text(prompt)
                .padding(12)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
}
