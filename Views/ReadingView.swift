import SwiftUI

struct ReadingView: View {
    @StateObject private var eyeTrackingService = EyeTrackingService()
    @State private var article: Article = SampleArticles.articles.first!
    @State private var highlightedWord: String?
    @State private var selectedWord: String?
    @AppStorage("fontSize") private var fontSize: FontSize = .medium
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text(article.title)
                        .font(.system(size: fontSize.size + 12))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                    
                    // Status indicator
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 20))
                        Text(eyeTrackingService.trackingStatus)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Article content
                    WordFlowLayout(
                        words: article.content.components(separatedBy: .whitespacesAndNewlines),
                        highlightedWord: $highlightedWord,
                        difficultWords: article.difficultWords,
                        eyeTrackingService: eyeTrackingService,
                        fontSize: fontSize,
                        onWordSelected: { word in
                            withAnimation(.spring()) {
                                selectedWord = word
                            }
                        }
                    )
                    .font(.system(size: fontSize.size))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 24)
                    
                    // Definition area
                    DefinitionArea(
                        word: selectedWord,
                        definition: selectedWord.flatMap { article.difficultWords[$0] },
                        fontSize: fontSize
                    )
                    
                    // Vocabulary section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Vocabulary")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 8)
                        
                        ForEach(Array(article.difficultWords.keys.sorted()), id: \.self) { word in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(word)
                                    .font(.system(size: fontSize.size))
                                    .bold()
                                Text(article.difficultWords[word] ?? "")
                                    .font(.system(size: fontSize.size - 2))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(radius: 2)
                            )
                        }
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(maxWidth: geometry.size.width)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(FontSize.allCases, id: \.self) { size in
                            Button(action: {
                                withAnimation {
                                    fontSize = size
                                }
                            }) {
                                HStack {
                                    Text(size.rawValue)
                                    if fontSize == size {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "textformat.size")
                            .font(.system(size: 20))
                    }
                }
            }
        }
    }
}

struct DefinitionArea: View {
    let word: String?
    let definition: String?
    let fontSize: FontSize
    
    var body: some View {
        if let word = word, let definition = definition {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 28))
                    
                    Text("See the definition of the word here!")
                        .font(.system(size: fontSize.size - 2))
                        .foregroundColor(.secondary)
                }
                
                Text(word)
                    .font(.system(size: fontSize.size + 4))
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(definition)
                    .font(.system(size: fontSize.size))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
            )
            .padding(.horizontal, 20)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
}

#Preview {
    ReadingView()
}