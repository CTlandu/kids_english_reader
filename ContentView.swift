import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            IntroductionView()
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
        }
    }
}

#Preview {
    ContentView()
}
