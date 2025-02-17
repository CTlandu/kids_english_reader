import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            IntroductionView()
                .tabItem {
                    Label("Introduction", systemImage: "info.circle")
                }
                .tag(0)
            
            TutorialView()
                .tabItem {
                    Label("Tutorial", systemImage: "book.fill")
                }
                .tag(1)
            
            ReadingView()
                .tabItem {
                    Label("Read", systemImage: "text.book.closed.fill")
                }
                .tag(2)
        }
    }
}

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
