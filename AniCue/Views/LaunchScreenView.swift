import SwiftUI

struct LaunchScreenView: View {
    @State private var opacity = 1.0
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
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.4)) {
                    opacity = 0.0
                }
            }
        }
    }
}
#Preview {
    LaunchScreenView()
}
