import SwiftUI
import CoreText

struct WordFlowLayout: View {
    let words: [String]
    @Binding var highlightedWord: String?
    let difficultWords: [String: String]
    let eyeTrackingService: EyeTrackingService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(splitIntoSentences(), id: \.self) { sentence in
                HStack(alignment: .center, spacing: 2) {
                    ForEach(sentence, id: \.self) { word in
                        if difficultWords.keys.contains(word) {
                            Button(action: {
                                highlightedWord = word
                            }) {
                                Text(word)
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(
                                        Rectangle()
                                            .fill(Color.yellow.opacity(0.3))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .fixedSize()
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel(word)
                            .accessibilityHint("Look at this word to see its definition")
                        } else {
                            Text(word)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        Text(" ")
                            .fixedSize()
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                Spacer().frame(height: 4)
            }
            
            // 测试用的选中状态显示
            if let highlightedWord = highlightedWord {
                Text("\"\(highlightedWord)\": 被选中")
                    .font(.caption)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.yellow.opacity(0.2))
                    )
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(), value: highlightedWord)
            }
            
            // 词义解释视图
            if let highlightedWord = highlightedWord,
               let definition = difficultWords[highlightedWord] {
                WordDefinitionView(word: highlightedWord, definition: definition)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // 将文本分割成句子
    private func splitIntoSentences() -> [[String]] {
        let sentences = words.joined(separator: " ")
            .components(separatedBy: ". ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        return sentences.map { sentence in
            sentence.components(separatedBy: .whitespaces)
                .filter { !$0.isEmpty }
        }
    }
}

// 用于实现流式布局的辅助视图
struct FlowLayout: Layout {
    var alignment: HorizontalAlignment = .leading
    var spacing: CGFloat = 0
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            alignment: alignment,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            alignment: alignment,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            let point = result.points[index]
            subview.place(at: CGPoint(x: point.x + bounds.minX, y: point.y + bounds.minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var points: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, alignment: HorizontalAlignment, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            var lineStart = 0
            
            for (index, subview) in subviews.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && lineStart < index {
                    // 换行
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                    lineStart = index
                }
                
                points.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

struct WordDefinitionView: View {
    let word: String
    let definition: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(word)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(definition)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 4)
        )
        .padding(.vertical, 8)
    }
} 