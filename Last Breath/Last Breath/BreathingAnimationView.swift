import SwiftUI

struct BreathingAnimationView: View {
    let isBreathing: Bool
    let phase: BreathingViewModel.BreathingPhase
    @State private var animationScale: CGFloat = 1.0
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background waves
            ForEach(0..<3) { i in
                WaveShape(offset: waveOffset + CGFloat(i) * 10)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "8A6FDF").opacity(0.3 - Double(i) * 0.1),
                                Color(hex: "322B5C").opacity(0.2 - Double(i) * 0.05)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .scaleEffect(animationScale)
            }
            
            // Main breathing indicator
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "8A6FDF"),
                            Color(hex: "322B5C")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .scaleEffect(animationScale)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                )
                .shadow(color: Color(hex: "8A6FDF").opacity(0.3), radius: 15)
        }
        .onChange(of: phase) { _ in
            updateAnimation()
        }
    }
    
    private func updateAnimation() {
        withAnimation(.easeInOut(duration: 2)) {
            switch phase {
            case .inhaleNose:
                animationScale = 1.3
                waveOffset += 20
            case .holdAfterInhale:
                animationScale = 1.3
            case .exhaleMouth:
                animationScale = 1.0
                waveOffset -= 20
            case .holdAfterExhale:
                animationScale = 1.0
            default:
                animationScale = 1.0
            }
        }
    }
}

struct WaveShape: Shape {
    let offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.5
        let wavelength = width
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let y = midHeight + sin(relativeX * 2 * .pi + offset) * 20
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
} 