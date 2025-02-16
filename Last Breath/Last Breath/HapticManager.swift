import Foundation
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        // Pre-prepare generators
        impactGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    func playPhaseTransition() {
        impactGenerator.impactOccurred(intensity: 0.5)
    }
    
    func playBreathTransition() {
        selectionGenerator.selectionChanged()
    }
    
    func playRepCompletion() {
        notificationGenerator.notificationOccurred(.success)
    }
    
    func playSessionComplete() {
        notificationGenerator.notificationOccurred(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.notificationGenerator.notificationOccurred(.success)
        }
    }
} 