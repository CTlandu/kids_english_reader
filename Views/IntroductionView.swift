import SwiftUI

struct IntroductionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "eyes")
                .font(.system(size: 60))
            
            Text("Welcome to EyeRead")
                .font(.title)
            
            Text("An eye-tracking assisted reading app for children")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    IntroductionView()
} 