import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: BreathingViewModel
    private let hapticManager = HapticManager.shared
    
    var backgroundColor: Color {
        colorScheme == .dark ? .black : Color(hex: "F8F7FF")
    }
    
    var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(hex: "1C1C1E") : .white
    }
    
    var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var secondaryTextColor: Color {
        colorScheme == .dark ? .gray : .gray
    }
    
    var accentColor: Color {
        colorScheme == .dark ? .purple.opacity(0.8) : .purple
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 10) {
                        // Breathing Durations Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Breathing Duration")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(textColor)
                                .padding(.bottom, 4)
                            
                            DurationCard(
                                title: "Inhale",
                                subtitle: "",
                                duration: $viewModel.inhaleDuration,
                                icon: "arrow.up.circle.fill",
                                backgroundColor: cardBackgroundColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                accentColor: accentColor
                            )
                            
                            DurationCard(
                                title: "Hold After Inhale",
                                subtitle: "",
                                duration: $viewModel.holdAfterInhaleDuration,
                                icon: "pause.circle.fill",
                                backgroundColor: cardBackgroundColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                accentColor: accentColor
                            )
                            
                            DurationCard(
                                title: "Exhale",
                                subtitle: "",
                                duration: $viewModel.exhaleDuration,
                                icon: "arrow.down.circle.fill",
                                backgroundColor: cardBackgroundColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                accentColor: accentColor
                            )
                            
                            DurationCard(
                                title: "Hold After Exhale",
                                subtitle: "",
                                duration: $viewModel.holdAfterExhaleDuration,
                                icon: "pause.circle.fill",
                                backgroundColor: cardBackgroundColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                accentColor: accentColor
                            )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(cardBackgroundColor)
                                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 10)
                        )
                        
                        // Repetitions Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Repetitions")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(textColor)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Number of cycles")
                                        .foregroundColor(secondaryTextColor)
                                    Text("\(viewModel.totalReps) cycles")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(textColor)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 20) {
                                    Button {
                                        if viewModel.totalReps > 1 {
                                            viewModel.totalReps -= 1
                                            hapticManager.playBreathTransition()
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(secondaryTextColor)
                                    }
                                    
                                    Button {
                                        if viewModel.totalReps < 10 {
                                            viewModel.totalReps += 1
                                            hapticManager.playBreathTransition()
                                        }
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(accentColor)
                                    }
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(cardBackgroundColor)
                                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 10)
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }
            }
        }
    }
}

struct DurationCard: View {
    let title: String
    let subtitle: String
    @Binding var duration: Int
    let icon: String
    let backgroundColor: Color
    let textColor: Color
    let secondaryTextColor: Color
    let accentColor: Color
    private let hapticManager = HapticManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(accentColor)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
            }
            
            HStack {
                Text("\(duration) seconds")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        if duration > 1 {
                            duration -= 1
                            hapticManager.playBreathTransition()
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(secondaryTextColor)
                    }
                    
                    Button {
                        if duration < 30 {
                            duration += 1
                            hapticManager.playBreathTransition()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(accentColor)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .shadow(color: Color.black.opacity(0.05), radius: 5)
        )
    }
}