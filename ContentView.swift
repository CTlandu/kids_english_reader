import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int
    
    init(initialTab: Int = 0) {
        _selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            IntroductionView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Introduction", systemImage: "info.circle")
                }
                .tag(0)
            
            TutorialView()
                .tabItem {
                    Label("Tutorial", systemImage: "book.fill")
                }
                .tag(1)
            
            ReadingView()
                .tabItem {
                    Label("Read", systemImage: "text.book.closed.fill")
                }
                .tag(2)
            
            VisionLimitationView()
                .tabItem {
                    Label("Vision", systemImage: "eye.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
