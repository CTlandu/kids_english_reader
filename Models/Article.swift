import Foundation

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let targetAge: ClosedRange<Int>
    let difficultWords: [String: String] // 单词: 释义
    
    // 实现 Hashable 协议
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // 实现相等性比较
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
} 