//
//  ErrorBanner.swift
//  TMDB
//
//  Created by Jorge Ramos on 08/06/25.
//
import SwiftUI

struct ErrorBanner: View {
    let message: String

    var body: some View {
        Text("⚠️ \(message)")
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}
