import SwiftUI

struct MainTabView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView {
                    HomeView().tabItem { Label("Home", systemImage: "house.fill") }
                    SearchView().tabItem { Label("Search", systemImage: "magnifyingglass") }
                    LibraryView().tabItem { Label("Your Library", systemImage: "books.vertical.fill") }
                }.tint(ColorPalette.accent)
                VStack(spacing: 6) { MiniPlayerView(); Color.clear.frame(height: 48) }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}

typealias TabBarView = MainTabView
