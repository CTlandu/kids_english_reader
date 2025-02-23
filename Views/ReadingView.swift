import SwiftUI

enum FontSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    var size: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        case .large: return 22
        }
    }
}

struct ReadingView: View {
    @StateObject private var eyeTrackingService = EyeTrackingService()
    @State private var selectedArticle: Article? = SampleArticles.articles.first
    @State private var highlightedWord: String?
    @AppStorage("fontSize") private var fontSize: FontSize = .medium
    
    var body: some View {
        NavigationSplitView {
            // 左侧边栏 - 文章列表
            List(SampleArticles.articles, selection: $selectedArticle) { article in
                Text(article.title)
            }
            .navigationTitle("Articles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: 实现文件导入
                    }) {
                        Image(systemName: "doc.badge.plus")
                    }
                }
            }
        } detail: {
            // 右侧详情视图 - 文章内容
            if let article = selectedArticle {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // 标题
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
                            
                            // 状态指示器
                            HStack {
                                Image(systemName: eyeTrackingService.isTrackingAvailable ? "eyes" : "eyes.slash")
                                    .foregroundColor(eyeTrackingService.isTrackingAvailable ? .green : .red)
                                Text(eyeTrackingService.trackingStatus)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // 文章内容
                            WordFlowLayout(
                                words: article.content.components(separatedBy: .whitespacesAndNewlines),
                                highlightedWord: $highlightedWord,
                                difficultWords: article.difficultWords,
                                eyeTrackingService: eyeTrackingService,
                                fontSize: fontSize
                            )
                            .font(.system(size: fontSize.size))
                            
                            Spacer(minLength: 32)
                            
                            // Vocabulary 部分
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
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.yellow.opacity(0.1))
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .frame(maxWidth: geometry.size.width)
                    }
                }
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