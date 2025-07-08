import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image("Upani")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                Spacer()
                Text("Upani")
                    .font(.system(size: 38, weight: .light, design: .rounded))
                    .foregroundColor(.teal.opacity(0.8))
                    .padding(.bottom, 50)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    LaunchScreenView()
}
