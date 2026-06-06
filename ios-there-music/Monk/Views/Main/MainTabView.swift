import SwiftUI

struct MainTabView: View {
    @State private var showSearch = false
    @EnvironmentObject private var player: PlayerManager

    var body: some View {
        ZStack(alignment: .bottom) {
            // Native TabView — automatic Liquid Glass on iOS 26
            #if compiler(>=6.2)
            nativeTabView
            #else
            fallbackTabView
            #endif

            // Mini player above tab bar
            if player.currentTrack != nil {
                VStack(spacing: 0) {
                    MiniPlayerView()
                    Spacer().frame(height: 50) // tab bar height
                }
                .padding(.bottom, 32)
            }

            // Floating search button on the right, above tab bar
            searchButton
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
        }
    }

    // MARK: - Native iOS 26 TabView (3 tabs — no Создать)

    #if compiler(>=6.2)
    @ViewBuilder
    private var nativeTabView: some View {
        TabView {
            Tab("Главная", systemImage: "house.fill") {
                NavigationStack { HomeView() }
            }

            Tab("Избранное", systemImage: "heart.fill") {
                NavigationStack { LibraryView() }
            }

            Tab("Профиль", systemImage: "person.fill") {
                NavigationStack { ProfileView() }
            }
        }
    }
    #endif

    // MARK: - Fallback TabView (Xcode 16)

    private var fallbackTabView: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Главная", systemImage: "house.fill") }
            NavigationStack { LibraryView() }
                .tabItem { Label("Избранное", systemImage: "heart.fill") }
            NavigationStack { ProfileView() }
                .tabItem { Label("Профиль", systemImage: "person.fill") }
        }
    }

    // MARK: - Floating Search Button (separate from tab bar)

    private var searchButton: some View {
        Button {
            showSearch = true
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
        }
        #if compiler(>=6.2)
        .glassEffect(in: .rect(cornerRadius: 23))
        #else
        .background(.ultraThinMaterial, in: Circle())
        #endif
        .padding(.trailing, 16)
        .padding(.bottom, 52)
    }
}

typealias TabBarView = MainTabView
