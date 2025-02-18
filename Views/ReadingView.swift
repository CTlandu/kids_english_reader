import SwiftUI

struct ReadingView: View {
    @State private var selectedArticle: Article? = SampleArticles.articles.first
    @State private var showingSidebar = false
    
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
                        
                        Text(article.content)
                            .font(.body)
                            .lineSpacing(8)
                        
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
            } else {
                Text("Select an article to begin reading")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ReadingView()
} 