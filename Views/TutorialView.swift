import SwiftUI

struct TutorialView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Title
                Text("How to Use EyeRead")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 40)
                
                // Tutorial Steps
                VStack(spacing: 30) {
                    TutorialStep(
                        step: 1,
                        title: "Position Your Device",
                        description: "Hold your iPad at a comfortable reading distance",
                        animation: AnyView(DevicePositioningAnimation())
                    )
                    
                    TutorialStep(
                        step: 2,
                        title: "Eye Tracking Permission",
                        description: "Allow eye tracking when prompted",
                        animation: AnyView(PermissionAnimation())
                    )
                    
                    TutorialStep(
                        step: 3,
                        title: "Go to 'Read' tab, Reading with Eyes",
                        description: "Focus on words to see their meanings",
                        animation: AnyView(ReadingAnimation())
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TutorialStep: View {
    let step: Int
    let title: String
    let description: String
    let animation: AnyView
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Step number and title
            HStack(alignment: .center) {
                Circle()
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("\(step)")
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                
                Text(title)
                    .font(.title2)
                    .bold()
            }
            
            // Animation area
            animation
                .frame(height: step == 2 ? 600 : 200)
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(16)
            
            // Description
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

// Device Positioning Animation
struct DevicePositioningAnimation: View {
    @State private var deviceOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Device outline
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: 120, height: 160)
                .offset(y: deviceOffset)
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: deviceOffset)
                .onAppear {
                    deviceOffset = -20
                }
            
            // Face icon
            Image(systemName: "face.smiling")
                .font(.system(size: 40))
                .foregroundColor(.blue)
        }
    }
}

// Permission Animation
struct PermissionAnimation: View {
    var body: some View {
        Image("accessibility_demo")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding()
    }
}

// Reading Animation
struct ReadingAnimation: View {
    @State private var highlightedWord = false
    @State private var showDefinition = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Sample text
                Text("The quick brown fox")
                    .font(.system(size: 20))
                
                // Highlighted word
                Text("jumps")
                    .font(.system(size: 20))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(highlightedWord ? Color.yellow.opacity(0.3) : Color.clear)
                    .animation(.easeInOut(duration: 1), value: highlightedWord)
                
                Text("over the lazy dog")
                    .font(.system(size: 20))
                
                if showDefinition {
                    // Word definition
                    Text("jump: to push oneself off a surface and into the air")
                        .font(.caption)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                highlightedWord = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        showDefinition = true
                    }
                }
            }
        }
    }
}

#Preview {
    TutorialView()
} 