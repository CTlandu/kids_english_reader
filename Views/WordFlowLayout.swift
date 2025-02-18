import SwiftUI
import CoreText

struct WordFlowLayout: View {
    let words: [String]
    @Binding var highlightedWord: String?
    let difficultWords: [String: String]
    @State private var wordFrames: [String: CGRect] = [:]
    let eyeTrackingService: EyeTrackingService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(words.joined(separator: " "))
                .font(.body)
                .lineSpacing(8)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            calculateWordFrames(in: geometry)
                        }
                    }
                )
                .foregroundColor(Color.primary)
            
            if let highlightedWord = highlightedWord,
               eyeTrackingService.showWordDefinition,
               let definition = difficultWords[highlightedWord] {
                WordDefinitionView(word: highlightedWord, definition: definition)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private func calculateWordFrames(in geometry: GeometryProxy) {
        let attributedString = NSAttributedString(
            string: words.joined(separator: " "),
            attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.lineSpacing = 8
                    return style
                }()
            ]
        )
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let path = CGPath(rect: geometry.frame(in: .local), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        var newWordFrames: [String: CGRect] = [:]
        var currentIndex = 0
        
        let lines = CTFrameGetLines(frame) as! [CTLine]
        var lineOrigins = Array(repeating: CGPoint.zero, count: lines.count)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
        
        for (lineIndex, line) in lines.enumerated() {
            let lineOrigin = lineOrigins[lineIndex]
            let runs = CTLineGetGlyphRuns(line) as! [CTRun]
            
            for run in runs {
                let runRange = CTRunGetStringRange(run)
                let runStart = runRange.location
                let runLength = runRange.length
                
                let runString = (attributedString.string as NSString).substring(with: NSRange(location: runStart, length: runLength))
                let runWords = runString.components(separatedBy: " ")
                
                for word in runWords {
                    if currentIndex < words.count && words[currentIndex] == word {
                        var runBounds = CTRunGetImageBounds(run, nil, CFRangeMake(0, 0))
                        runBounds.origin.y = geometry.size.height - lineOrigin.y - runBounds.height
                        
                        newWordFrames[word] = runBounds
                        currentIndex += 1
                    }
                }
            }
        }
        
        wordFrames = newWordFrames
        eyeTrackingService.updateWordFrames(newWordFrames)
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