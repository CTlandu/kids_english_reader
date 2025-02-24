import SwiftUI

struct VisionLimitationView: View {
    @State private var selectedVisionCard: Int?
    @State private var showLimitations = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Title
                Text("Vision & Limitations")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 40)
                
                // Vision Section
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Our Vision")
                            .font(.title)
                            .bold()
                        
                        Image(systemName: "eye.fill")
                            .foregroundStyle(.blue)
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                    
                    // Vision Cards
                    VStack(spacing: 16) {
                        VisionCard(
                            icon: "doc.text.fill",
                            title: "Custom Content Import",
                            description: "Import your own PDF or text files to create personalized reading materials for children.",
                            isExpanded: selectedVisionCard == 0,
                            onTap: { selectedVisionCard = selectedVisionCard == 0 ? nil : 0 }
                        )
                        
                        VisionCard(
                            icon: "network",
                            title: "Smart Word Definitions",
                            description: "Future integration with online services and AI to provide comprehensive word explanations, including images, videos, and related examples.",
                            isExpanded: selectedVisionCard == 1,
                            onTap: { selectedVisionCard = selectedVisionCard == 1 ? nil : 1 }
                        )
                        
                        VisionCard(
                            icon: "eyes.inverse",
                            title: "Focus Tracking",
                            description: "Monitor reading engagement through eye tracking, helping parents identify and support children with ADHD or attention challenges.",
                            isExpanded: selectedVisionCard == 2,
                            onTap: { selectedVisionCard = selectedVisionCard == 2 ? nil : 2 }
                        )
                        
                        VisionCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Reading Pattern Analysis",
                            description: "Track and analyze children's reading patterns to identify and correct potential reading habits early.",
                            isExpanded: selectedVisionCard == 3,
                            onTap: { selectedVisionCard = selectedVisionCard == 3 ? nil : 3 }
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10)
                
                // Limitations Section
                VStack(alignment: .leading, spacing: 24) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showLimitations.toggle()
                        }
                    }) {
                        HStack {
                            Text("Current Limitations")
                                .font(.title)
                                .bold()
                            
                            Image(systemName: showLimitations ? "chevron.up" : "chevron.down")
                                .foregroundStyle(.blue)
                                .font(.title2)
                                .animation(.spring(), value: showLimitations)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if showLimitations {
                        VStack(spacing: 20) {
                            LimitationCard(
                                icon: "exclamationmark.triangle",
                                title: "Eye Tracking Precision",
                                description: "While innovative, the current eye tracking technology requires frequent calibration and has accuracy limitations. We're excited about future improvements to enhance the user experience."
                            )
                            
                            LimitationCard(
                                icon: "lock.fill",
                                title: "API Accessibility",
                                description: "Currently, direct access to eye tracking data is limited. We look forward to expanded API access, which would enable us to create even more powerful accessibility features for users with disabilities."
                            )
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10)
            }
            .padding(.horizontal)
        }
    }
}

struct VisionCard: View {
    let icon: String
    let title: String
    let description: String
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundStyle(.blue)
                    
                    Text(title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.spring(), value: isExpanded)
                }
                
                if isExpanded {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LimitationCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(.orange)
                
                Text(title)
                    .font(.headline)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    VisionLimitationView()
} 