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
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue.opacity(0.1))
                        )
                    
                    // Status indicator
                    HStack {
                        Image(systemName: eyeTrackingService.isTrackingAvailable ? "eyes" : "eyes.slash")
                            .foregroundColor(eyeTrackingService.isTrackingAvailable ? .green : .red)
                        Text(eyeTrackingService.trackingStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
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
                    .background(Color.red.opacity(0.1))
                    
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
            VStack(spacing: 12) {
                HStack(alignment: .top) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 24))
                    Spacer()
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
            .padding(20)
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