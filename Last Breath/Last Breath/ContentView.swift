//
//  ContentView.swift
//  Last Breath
//
//  Created by Alluri santosh Varma on 2/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BreathingViewModel()
    @State private var isAnimating = false
    @State private var showingSettings = false
    @State private var circleScale: CGFloat = 1.0
    @State private var circleColor: Color = Color(hex: "322B5C")
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var displayFor: Int = 4  // Added for initial display
    @State private var displayReps: Int = 12  // Added for initial display
    
    var backgroundColor: Color {
        colorScheme == .dark ? .black : Color(hex: "F8F7FF")
    }
    
    var defaultCircleColor: Color {
        colorScheme == .dark ? .white : Color(hex: "322B5C")
    }
    
    var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var secondaryTextColor: Color {
        colorScheme == .dark ? .gray : .gray
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("Last Breath")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.red)
                    Spacer()
                    Button(action: { showingSettings = true }) {
                        Text("more")
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .regular))
                    }
                }
                .padding(.horizontal)
                
                // Phase indicators
                VStack(alignment: .leading, spacing: 4) {
                    Text("Don't worry /")
                    Text("My love /")
                    Text("Just /")
                    Text("Breathe /")
                }
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(textColor)
                .padding(.horizontal)
                
                // Centered animated circle with removed outer circle
                GeometryReader { geometry in
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    (circleColor == defaultCircleColor ? 
                                        defaultCircleColor : circleColor).opacity(0.8),
                                    (circleColor == defaultCircleColor ? 
                                        defaultCircleColor : circleColor).opacity(0.6)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 250, height: 250)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(circleScale)
                        .blur(radius: 0.5)
                        .onChange(of: viewModel.currentPhase) { newPhase in
                            updateCircleAnimation(for: newPhase)
                        }
                }
                
                // Bottom controls
                VStack(spacing: 30) {
                    if viewModel.isActive {
                        Button(action: { viewModel.stopBreathing() }) {
                            Text("STOP")
                                .foregroundColor(.red)
                                .font(.system(size: 24, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        // Left side - Main text
                        VStack(alignment: .leading) {
                            Text(viewModel.currentPhase.prefixText)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(secondaryTextColor)
                            Text(viewModel.currentPhase.mainText)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(textColor)
                        }
                        
                        Spacer()
                        
                        // Right side - Timers
                        HStack(spacing: 40) {
                            VStack(alignment: .leading) {
                                Text("FOR")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(secondaryTextColor)
                                Text("\(String(format: "%02d", viewModel.isActive ? viewModel.displaySeconds : 4))")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(textColor)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("REPS")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(secondaryTextColor)
                                Text("\(String(format: "%02d", viewModel.isActive ? viewModel.displayReps : 12))")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(textColor)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !viewModel.isActive {
                            viewModel.startBreathing()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(viewModel: viewModel)
                .transition(.move(edge: .trailing))
        }
        .onAppear {
            isAnimating = true
            circleColor = defaultCircleColor
        }
    }
    
    private func updateCircleAnimation(for phase: BreathingViewModel.BreathingPhase) {
        switch phase {
        case .inhaleNose:
            withAnimation(.easeInOut(duration: TimeInterval(viewModel.inhaleDuration))) {
                circleScale = 1.4
                circleColor = colorScheme == .dark ? .white : .black
            }
        case .holdAfterInhale:
            withAnimation(.easeInOut(duration: 0.3)) {
                circleColor = .pink
            }
        case .exhaleMouth:
            withAnimation(.easeInOut(duration: TimeInterval(viewModel.exhaleDuration))) {
                circleScale = 1.0
                circleColor = colorScheme == .dark ? .white : .black
            }
        case .holdAfterExhale:
            withAnimation(.easeInOut(duration: 0.3)) {
                circleColor = .blue
            }
        case .start:
            withAnimation(.easeInOut(duration: 0.3)) {
                circleScale = 1.0
                circleColor = defaultCircleColor
            }
        }
    }
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
