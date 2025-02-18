import SwiftUI

struct TutorialView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("How to Use EyeRead")
                .font(.title)
            
            List {
                HowToUseRow(step: "1", title: "Position your device", description: "Make sure your device is at a comfortable reading distance")
                HowToUseRow(step: "2", title: "Allow eye tracking", description: "Grant permission to use eye tracking features")
                HowToUseRow(step: "3", title: "Start reading", description: "Select a text and begin reading naturally")
            }
        }
    }
}

struct HowToUseRow: View {
    let step: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(step)")
                .font(.headline)
            Text(title)
                .font(.subheadline)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TutorialView()
} 