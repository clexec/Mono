import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var showSearch = false

    enum Tab: Int, CaseIterable {
        case home, favorites, create, profile
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Main content
                Group {
                    switch selectedTab {
                    case .home: HomeView()
                    case .favorites: LibraryView()
                    case .create: CreatePlaylistView()
                    case .profile: ProfileView()
                    }
                }
                .padding(.bottom, 100)

                // Mini player + Custom tab bar
                VStack(spacing: 6) {
                    MiniPlayerView()
                    customTabBar
                }
                .padding(.bottom, 6)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showSearch) {
            NavigationStack {
                SearchView()
            }
        }
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack(spacing: 6) {
            // Main tab bar container with glass effect
            HStack(spacing: 0) {
                tabItem(tab: .home, icon: "house.fill", label: "Главная")
                tabItem(tab: .favorites, icon: "heart.fill", label: "Избранное")
                tabItem(tab: .create, icon: "plus", label: "Создать")
                tabItem(tab: .profile, icon: "person.fill", label: "Профиль")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .modifier(LiquidGlassBackgroundModifier(cornerRadius: 24))

            // Separate search button — circular, with glass effect
            Button {
                showSearch = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
            }
            .modifier(LiquidGlassBackgroundModifier(cornerRadius: 25))
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Tab Item

    private func tabItem(tab: Tab, icon: String, label: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(label)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(selectedTab == tab ? ColorPalette.accent : .white.opacity(0.7))
            .frame(maxWidth: .infinity)
        }
    }
}

typealias TabBarView = MainTabView
