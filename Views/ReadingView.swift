import SwiftUI

struct ReadingView: View {
    @StateObject private var eyeTrackingService = EyeTrackingService()
    @State private var selectedArticle: Article? = SampleArticles.articles.first
    @State private var showingSidebar = false
    @State private var highlightedWord: String?
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(SampleArticles.articles, selection: $selectedArticle) { article in
                Text(article.title)
            }
            .navigationTitle("Articles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { 
                        // TODO: Implement file import
                    }) {
                        Image(systemName: "doc.badge.plus")
                    }
                }
            }
        } detail: {
            // Article View
            if let article = selectedArticle {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(article.title)
                            .font(.title)
                            .padding(.bottom)
                        
                        // Status indicator
                        HStack {
                            Image(systemName: eyeTrackingService.isTrackingAvailable ? "eyes" : "eyes.slash")
                                .foregroundColor(eyeTrackingService.isTrackingAvailable ? .green : .red)
                            Text(eyeTrackingService.trackingStatus)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom)
                        
                        WordFlowLayout(
                            words: article.content.components(separatedBy: .whitespacesAndNewlines),
                            highlightedWord: $highlightedWord,
                            difficultWords: article.difficultWords,
                            eyeTrackingService: eyeTrackingService
                        )
                        .onChange(of: highlightedWord) { oldWord, newWord in
                            if let word = newWord {
                                print("单词被选中: \(word)")
                                // 3秒后自动清除选中状态
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    if highlightedWord == word {
                                        highlightedWord = nil
                                    }
                                }
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Vocabulary")
                                .font(.headline)
                            
                            ForEach(Array(article.difficultWords.keys.sorted()), id: \.self) { word in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(word)
                                        .font(.subheadline)
                                        .bold()
                                    Text(article.difficultWords[word] ?? "")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                }
                .onAppear {
                    eyeTrackingService.startTracking()
                }
                .onDisappear {
                    eyeTrackingService.stopTracking()
                }
            } else {
                Text("Select an article to begin reading")
                    .foregroundColor(.secondary)
            }
        }
        .alert("Eye Tracking Not Available", isPresented: .constant(!eyeTrackingService.isTrackingAvailable)) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The eye tracking feature has not been enabled for this device.")
        }
    }
}

#Preview {
    ReadingView()
} 