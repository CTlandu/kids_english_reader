import SwiftUI

// 先定义 FeatureCard
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// 然后定义 IntroductionView
struct IntroductionView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Hero Section
                VStack(spacing: 24) {
                    Image(systemName: "eyes")
                        .font(.system(size: 80))
                        .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .symbolEffect(.pulse)
                    
                    Text("EyeRead")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                    
                    Text("Learning English Through Your Eyes")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                
                // Feature Cards
                VStack(spacing: 20) {
                    FeatureCard(
                        icon: "hand.raised.slash.fill",
                        title: "Hands-free Learning",
                        description: "Navigate and learn using only your eyes"
                    )
                    
                    FeatureCard(
                        icon: "book.fill",
                        title: "Interactive Reading",
                        description: "Focus on words to see their meanings instantly"
                    )
                    
                    FeatureCard(
                        icon: "person.fill.checkmark",
                        title: "Accessible for Everyone",
                        description: "Designed for children with mobility challenges"
                    )
                }
                
                // Mission Statement
                VStack(spacing: 16) {
                    Text("Our Mission")
                        .font(.title2)
                        .bold()
                    
                    Text("To empower every child with the ability to learn and explore English literature independently, regardless of physical limitations.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button(action: {
                        selectedTab = 3
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Learn More About Our Vision")
                        }
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.vertical, 20)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    IntroductionView(selectedTab: .constant(0))
} 