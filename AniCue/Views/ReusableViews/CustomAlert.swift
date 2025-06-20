//
//  CustomAlert.swift
//  AniCue
//
//  Created by Jorge Ramos on 20/06/25.
//
import SwiftUI

struct CustomAlert: View {
    let title: String
    let message: String
    let primaryAction: () -> Void
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button(action: dismiss) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.thinMaterial)
                        .foregroundColor(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                Button(action: primaryAction) {
                    Text("Clear All")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.gradient)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 30)
        .transition(.scale.combined(with: .opacity))
    }
}
