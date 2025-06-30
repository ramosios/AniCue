import SwiftUI

// Define main and accent colors for easy modification
let axolotlMainColor = Color(red: 0.8, green: 0.95, blue: 1.0)
let axolotlAccentColor = Color(red: 0.5, green: 0.8, blue: 1.0)

struct AxolotlView: View {
    @State private var isThinking = false
    @State private var isBlinking = false
    @State private var bubbleAnim = false
    var body: some View {
        ZStack {
            // Shadow
            Ellipse()
                .fill(Color.black.opacity(0.12))
                .frame(width: 90, height: 18)
                .offset(y: 110)
            // Tail with gradient
            Ellipse()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [axolotlAccentColor.opacity(0.7), axolotlAccentColor]),
                    startPoint: .top,
                    endPoint: .bottom))
                .frame(width: 40, height: 100)
                .rotationEffect(.degrees(isThinking ? 40 : 30))
                .offset(x: 0, y: 70)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            // Body with highlight
            Ellipse()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [axolotlMainColor, axolotlAccentColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(width: 70, height: 90)
                .offset(y: 60)
                .overlay(
                    Ellipse()
                        .fill(Color.white.opacity(0.22))
                        .frame(width: 30, height: 20)
                        .offset(x: -10, y: 40)
                )
                .rotationEffect(.degrees(isThinking ? -4 : 4))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            // Subtle white tummy
            Ellipse()
                .fill(Color.white.opacity(0.35))
                .frame(width: 36, height: 54)
                .offset(y: 70)
                .rotationEffect(.degrees(isThinking ? -4 : 4))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            // Hands
            AxolotlFin(isLeft: true, color1: axolotlAccentColor.opacity(0.7), color2: axolotlAccentColor)
                .offset(x: -38, y: 90)
                .rotationEffect(.degrees(isThinking ? -10 : 0))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            AxolotlFin(isLeft: false, color1: axolotlAccentColor.opacity(0.7), color2: axolotlAccentColor)
                .offset(x: 38, y: 90)
                .rotationEffect(.degrees(isThinking ? 10 : 0))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            AxolotlHead(isThinking: isThinking, isBlinking: isBlinking, mainColor: axolotlMainColor, accentColor: axolotlAccentColor)
                .offset(y: 0)
                .rotationEffect(.degrees(isThinking ? 6 : -6))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            // Loading text below the axolotl, not covering it
            VStack {
                Spacer()
                AnimatedLoadingText()
                    .padding(.top, 40)
            }
        }
        .frame(width: 180, height: 290) // Further increased height for more space below
        .onAppear {
            isThinking = true
            // Blinking
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.1)) { isBlinking = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    withAnimation(.easeInOut(duration: 0.1)) { isBlinking = false }
                }
            }
            // Bubbles
            withAnimation(Animation.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                bubbleAnim = true
            }
        }
    }
}

struct AxolotlHead: View {
    var isThinking: Bool = false
    var isBlinking: Bool = false
    var mainColor: Color = Color(red: 0.8, green: 0.95, blue: 1.0)
    var accentColor: Color = Color(red: 0.5, green: 0.8, blue: 1.0)
    var body: some View {
        ZStack {
            // 2 Antennae on the left
            AxolotlAntenna(angle: -55, color: accentColor)
                .offset(x: -48, y: -48)
                .rotationEffect(.degrees(isThinking ? -10 : 0))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            AxolotlAntenna(angle: -25, color: accentColor)
                .offset(x: -28, y: -54)
                .rotationEffect(.degrees(isThinking ? -5 : 0))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            // 2 Antennae on the right
            AxolotlAntenna(angle: 25, color: accentColor)
                .offset(x: 28, y: -54)
                .rotationEffect(.degrees(isThinking ? 5 : 0))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            AxolotlAntenna(angle: 55, color: accentColor)
                .offset(x: 48, y: -48)
                .rotationEffect(.degrees(isThinking ? 10 : 0))
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isThinking)
            // Head shape with gradient
            RoundedRectangle(cornerRadius: 40)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [mainColor, accentColor]),
                    startPoint: .top,
                    endPoint: .bottom))
                .frame(width: 110, height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(accentColor.opacity(0.25), lineWidth: 3)
                )
            // Blush
            Circle()
                .fill(accentColor.opacity(0.18))
                .frame(width: 22, height: 18)
                .offset(x: -36, y: 18)
            Circle()
                .fill(accentColor.opacity(0.18))
                .frame(width: 22, height: 18)
                .offset(x: 36, y: 18)
            // Gills
            AxolotlGill(angle: -40, color: accentColor)
            AxolotlGill(angle: -20, color: accentColor)
                .offset(x: -10)
            AxolotlGill(angle: 20, color: accentColor)
                .offset(x: 10)
            AxolotlGill(angle: 40, color: accentColor)
            // Eyes with highlight
            HStack(spacing: 32) {
                AxolotlEye(isBlinking: isBlinking)
                AxolotlEye(isBlinking: isBlinking)
            }
            .offset(y: 10)
            // Expressive mouth
            AxolotlExpressiveMouth(color: accentColor)
                .offset(y: 32)
        }
        .frame(width: 110, height: 90)
    }
}

struct AxolotlAntenna: View {
    var angle: Double
    var color: Color = Color(red: 0.5, green: 0.8, blue: 1.0)
    var body: some View {
        ZStack {
            // Main antenna (pointier)
            Path { path in
                path.move(to: CGPoint(x: 20, y: 80))
                path.addQuadCurve(
                    to: CGPoint(x: 20, y: 0),
                    control: CGPoint(x: 0, y: 10)
                )
            }
            .stroke(LinearGradient(
                gradient: Gradient(colors: [color, Color.white.opacity(0.7)]),
                startPoint: .bottom,
                endPoint: .top), lineWidth: 16)
            // Small hairs at the tip
            ForEach(0..<3) { i in
                Path { path in
                    let angleOffset = Double(i - 1) * 10.0
                    let tipX = 20 + 7 * cos((270 + angleOffset) * .pi / 180)
                    let tipY = 0 + 7 * sin((270 + angleOffset) * .pi / 180)
                    path.move(to: CGPoint(x: 20, y: 0))
                    path.addLine(to: CGPoint(x: tipX, y: tipY))
                }
                .stroke(color, lineWidth: 2)
            }
        }
        .frame(width: 40, height: 80)
        .rotationEffect(.degrees(angle))
    }
}

struct AxolotlFin: View {
    var isLeft: Bool
    var color1: Color = Color(red: 0.7, green: 0.9, blue: 1.0)
    var color2: Color = Color(red: 0.5, green: 0.8, blue: 1.0)
    var body: some View {
        ZStack {
            Path { path in
                if isLeft {
                    path.move(to: CGPoint(x: 16, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 2, y: 36), control: CGPoint(x: -8, y: 18))
                    path.addQuadCurve(to: CGPoint(x: 10, y: 39), control: CGPoint(x: 6, y: 48))
                    path.addQuadCurve(to: CGPoint(x: 16, y: 0), control: CGPoint(x: 28, y: 18))
                } else {
                    path.move(to: CGPoint(x: 2, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 16, y: 36), control: CGPoint(x: 26, y: 18))
                    path.addQuadCurve(to: CGPoint(x: 8, y: 39), control: CGPoint(x: 14, y: 48))
                    path.addQuadCurve(to: CGPoint(x: 2, y: 0), control: CGPoint(x: -10, y: 18))
                }
            }
            .fill(LinearGradient(
                gradient: Gradient(colors: [color1, color2]),
                startPoint: .top,
                endPoint: .bottom))
            .overlay(
                Path { path in
                    if isLeft {
                        path.move(to: CGPoint(x: 16, y: 0))
                        path.addQuadCurve(to: CGPoint(x: 2, y: 36), control: CGPoint(x: -8, y: 18))
                        path.addQuadCurve(to: CGPoint(x: 10, y: 39), control: CGPoint(x: 6, y: 48))
                        path.addQuadCurve(to: CGPoint(x: 16, y: 0), control: CGPoint(x: 28, y: 18))
                    } else {
                        path.move(to: CGPoint(x: 2, y: 0))
                        path.addQuadCurve(to: CGPoint(x: 16, y: 36), control: CGPoint(x: 26, y: 18))
                        path.addQuadCurve(to: CGPoint(x: 8, y: 39), control: CGPoint(x: 14, y: 48))
                        path.addQuadCurve(to: CGPoint(x: 2, y: 0), control: CGPoint(x: -10, y: 18))
                    }
                }
                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
            )
        }
        .frame(width: 20, height: 40)
        .rotationEffect(.degrees(isLeft ? -30 : 30))
    }
}

struct AxolotlGill: View {
    var angle: Double
    var color: Color = Color(red: 0.5, green: 0.8, blue: 1.0)
    var body: some View {
        Capsule()
            .fill(LinearGradient(
                gradient: Gradient(colors: [color.opacity(0.7), color.opacity(0.4)]),
                startPoint: .top,
                endPoint: .bottom))
            .frame(width: 8, height: 28)
            .rotationEffect(.degrees(angle))
            .offset(y: -20)
    }
}

struct AxolotlEye: View {
    var isBlinking: Bool = false
    var body: some View {
        ZStack {
            if isBlinking {
                Capsule()
                    .fill(Color.black)
                    .frame(width: 14, height: 4)
                    .offset(y: 4)
            } else {
                Circle()
                    .fill(Color.black)
                    .frame(width: 14, height: 14)
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 5, height: 5)
                    .offset(x: -3, y: -3)
            }
        }
    }
}

struct AxolotlExpressiveMouth: View {
    var color: Color = Color(red: 0.5, green: 0.8, blue: 1.0)
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 4, y: 10))
            path.addLine(to: CGPoint(x: 20, y: 10))
        }
        .stroke(color, lineWidth: 4)
        .frame(width: 24, height: 20)
    }
}
struct AxolotlHand: View {
    var isLeft: Bool
    var color: Color = Color(red: 0.7, green: 0.9, blue: 1.0)
    var body: some View {
        ZStack {
            // Palm
            Ellipse()
                .fill(color)
                .frame(width: 18, height: 12)
                .rotationEffect(.degrees(isLeft ? -20 : 20))
            // Fingers
            ForEach(0..<3) { i in
                Capsule()
                    .fill(color)
                    .frame(width: 4, height: 16)
                    .rotationEffect(.degrees(Double(i - 1) * 18 + (isLeft ? -20 : 20)))
                    .offset(y: -8)
            }
        }
        .frame(width: 24, height: 24)
        .rotationEffect(.degrees(isLeft ? -10 : 10))
    }
}

struct BubbleView: View {
    var offsetX: CGFloat
    var offsetY: CGFloat
    var delay: Double
    @Binding var anim: Bool
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.5))
            .frame(width: 16, height: 16)
            .scaleEffect(anim ? 1.0 : 0.5)
            .offset(x: offsetX, y: anim ? offsetY - 30 : offsetY)
            .opacity(anim ? 0.0 : 1.0)
            .animation(Animation.easeInOut(duration: 2.5).delay(delay).repeatForever(autoreverses: false), value: anim)
    }
}
struct AnimatedLoadingText: View {
    @State private var dots = ""
    let baseText = "Loading"
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var body: some View {
        Text("\(baseText)\(dots)")
            .font(.system(size: 24, weight: .heavy, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.8, green: 0.95, blue: 1.0),
                        Color(red: 0.5, green: 0.8, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: Color(red: 0.5, green: 0.8, blue: 1.0).opacity(0.35), radius: 4, x: 0, y: 3)
            .onReceive(timer) { _ in
                if dots.count >= 3 {
                    dots = ""
                } else {
                    dots += "."
                }
            }
    }
}

struct AxolotlView_Previews: PreviewProvider {
    static var previews: some View {
        AxolotlView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
