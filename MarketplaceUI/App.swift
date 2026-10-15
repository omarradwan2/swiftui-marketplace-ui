import SwiftUI

@main
struct MarketplaceUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack { FeedScreen() }.tabItem { Label("Deals", systemImage: "cart.fill") }
                SwipeScreen(deals: SampleData.deals).tabItem { Label("Swipe", systemImage: "rectangle.stack.fill") }
            }
            .preferredColorScheme(.dark)
            .tint(Palette.green)
        }
    }
}

enum Palette {
    static let green = Color(red: 0.17, green: 0.83, blue: 0.49)
    static let amber = Color(red: 1.0, green: 0.72, blue: 0.25)
    static let red = Color(red: 1.0, green: 0.36, blue: 0.36)
    static let surface = Color(white: 0.11)
    static let muted = Color(white: 0.6)
}
