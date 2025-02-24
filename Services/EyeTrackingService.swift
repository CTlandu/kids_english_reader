import SwiftUI

@MainActor
class EyeTrackingService: ObservableObject {
    @Published var highlightedWord: String?
    @Published var isTrackingAvailable: Bool = false
    @Published var showWordDefinition: Bool = false
    @Published var trackingStatus: String = "Use Eye tracking; stare at highlighted words to see definitions; or if staring doesn't work well; simply press the words to test"
    
    private var wordFrames: [String: CGRect] = [:]
    
    func updateWordFrames(_ frames: [String: CGRect]) {
        wordFrames = frames
    }
    
    func startTracking() {
        print("Eye tracking service placeholder - waiting for iOS 18 API")
        trackingStatus = "Waiting for iOS 18 Eye Tracking API"
    }
    
    func stopTracking() {
        print("Stop tracking called")
    }
} 