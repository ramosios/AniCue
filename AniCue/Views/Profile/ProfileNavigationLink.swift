//
//  ProfileNavigationLink.swift
//  AniCue
//
//  Created by Jorge Ramos on 20/06/25.
//
import SwiftUI
import Foundation
struct ProfileNavigationLink<Destination: View>: View {
    var title: String
    var icon: String
    var destination: Destination

    init(title: String, icon: String, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.icon = icon
        self.destination = destination()
    }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(Color.accentColor.opacity(0.1))
            .foregroundColor(.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
