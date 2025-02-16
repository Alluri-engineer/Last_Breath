import Foundation
import SwiftUI

class BreathingViewModel: ObservableObject {
    @Published var currentPhase: BreathingPhase = .start
    @Published var currentSeconds: Int = 0
    @Published var remainingReps: Int = 5
    @Published var isActive = false
    
    // Customizable durations
    @Published var inhaleDuration: Int = 5
    @Published var holdAfterInhaleDuration: Int = 5
    @Published var exhaleDuration: Int = 5
    @Published var holdAfterExhaleDuration: Int = 5
    @Published var totalReps: Int = 5
    
    @Published var isCompleted: Bool = false
    @Published var displaySeconds: Int = 0
    @Published var displayReps: Int = 0
    
    private var timer: Timer?
    private let hapticManager = HapticManager.shared
    
    enum BreathingPhase {
        case start
        case inhaleNose
        case holdAfterInhale
        case exhaleMouth
        case holdAfterExhale
        
        var mainText: String {
            switch self {
            case .start: return "START"
            case .inhaleNose: return "NOSE"
            case .holdAfterInhale: return "HOLD"
            case .exhaleMouth: return "MOUTH"
            case .holdAfterExhale: return "HOLD"
            }
        }
        
        var prefixText: String {
            switch self {
            case .start: return "TAP TO"
            case .inhaleNose: return "INHALE FROM"
            case .holdAfterInhale: return "AND"
            case .exhaleMouth: return "EXHALE FROM"
            case .holdAfterExhale: return "AND"
            }
        }
    }
    
    var currentPhaseDuration: Int {
        switch currentPhase {
        case .start: return 0
        case .inhaleNose: return inhaleDuration
        case .holdAfterInhale: return holdAfterInhaleDuration
        case .exhaleMouth: return exhaleDuration
        case .holdAfterExhale: return holdAfterExhaleDuration
        }
    }
    
    func startBreathing() {
        isActive = true
        isCompleted = false
        currentPhase = .inhaleNose
        remainingReps = totalReps
        currentSeconds = currentPhaseDuration
        displaySeconds = currentSeconds
        displayReps = remainingReps
        hapticManager.playPhaseTransition()
        startTimer()
    }
    
    func stopBreathing() {
        isActive = false
        currentPhase = .start
        currentSeconds = 0
        timer?.invalidate()
        timer = nil
        displaySeconds = 4
        displayReps = 12
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateBreathingCycle()
        }
    }
    
    private func updateDisplayValues() {
        displaySeconds = currentSeconds
        displayReps = remainingReps
    }
    
    private func updateBreathingCycle() {
        if currentSeconds > 0 {
            currentSeconds -= 1
            updateDisplayValues()
        } else {
            moveToNextPhase()
        }
    }
    
    private func moveToNextPhase() {
        switch currentPhase {
        case .start:
            currentPhase = .inhaleNose
            hapticManager.playPhaseTransition()
            
        case .inhaleNose:
            currentPhase = .holdAfterInhale
            hapticManager.playBreathTransition()
            
        case .holdAfterInhale:
            currentPhase = .exhaleMouth
            hapticManager.playPhaseTransition()
            
        case .exhaleMouth:
            currentPhase = .holdAfterExhale
            hapticManager.playBreathTransition()
            
        case .holdAfterExhale:
            if remainingReps > 1 {
                remainingReps -= 1
                currentPhase = .inhaleNose
                hapticManager.playRepCompletion()
            } else {
                isCompleted = true
                hapticManager.playSessionComplete()
                stopBreathing()
                return
            }
        }
        
        currentSeconds = currentPhaseDuration
        updateDisplayValues()
    }
}