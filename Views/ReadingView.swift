import SwiftUI

struct ReadingView: View {
    var body: some View {
        VStack {
            Text("Reading View")
                .font(.title)
            Text("Select a text to start reading")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ReadingView()
} 