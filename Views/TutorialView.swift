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
                        animation: AnyView(DevicePositionAnimation())
                    )
                    
                    TutorialStep(
                        step: 2,
                        title: "Enable Eye Tracking",
                        description: "Allow the app to track your eye movements",
                        animation: AnyView(EyeTrackingAnimation())
                    )
                    
                    TutorialStep(
                        step: 3,
                        title: "Start Reading",
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
            
            // Description
            Text(description)
                .foregroundColor(.secondary)
                .padding(.leading, 56)
            
            // Animation area
            animation
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(16)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}

struct DevicePositionAnimation: View {
    @State private var deviceOffset: CGFloat = -20
    
    var body: some View {
        Image(systemName: "ipad")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .offset(y: deviceOffset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
                ) {
                    deviceOffset = 20
                }
            }
    }
}

struct EyeTrackingAnimation: View {
    @State private var eyePosition: CGFloat = -10
    
    var body: some View {
        HStack(spacing: 30) {
            // Left eye
            Circle()
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .offset(x: eyePosition)
                )
            
            // Right eye
            Circle()
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .offset(x: eyePosition)
                )
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
            ) {
                eyePosition = 10
            }
        }
    }
}

struct ReadingAnimation: View {
    @State private var highlightedWordIndex = 0
    let words = ["Focus", "on", "any", "word", "to", "learn"]
    @State private var task: Task<Void, Never>?
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                Text(word)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(index == highlightedWordIndex ? Color.yellow.opacity(0.3) : Color.clear)
                    )
            }
        }
        .onAppear {
            // 创建新的异步任务
            task = Task { @MainActor in
                while !Task.isCancelled {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        highlightedWordIndex = (highlightedWordIndex + 1) % words.count
                    }
                    try? await Task.sleep(for: .seconds(1))
                }
            }
        }
        .onDisappear {
            // 取消任务
            task?.cancel()
            task = nil
        }
    }
}

#Preview {
    TutorialView()
} 