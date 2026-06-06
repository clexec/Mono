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
                .padding(.bottom, 90)

                // Mini player + Custom tab bar
                VStack(spacing: 6) {
                    MiniPlayerView()

                    // Compact tab bar with search button on the right
                    HStack(spacing: 8) {
                        // Tab bar — compressed to fit 4 items + search
                        HStack(spacing: 0) {
                            tabItem(tab: .home, icon: "house.fill", label: "Главная")
                            tabItem(tab: .favorites, icon: "heart.fill", label: "Избранное")
                            tabItem(tab: .create, icon: "plus", label: "Создать")
                            tabItem(tab: .profile, icon: "person.fill", label: "Профиль")
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 8)
                        #if compiler(>=6.2)
                        .glassEffect(in: .rect(cornerRadius: 22))
                        #else
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        #endif

                        // Separate search button
                        Button {
                            showSearch = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                        }
                        #if compiler(>=6.2)
                        .glassEffect(in: .rect(cornerRadius: 22))
                        #else
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        #endif
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.bottom, 4)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
        }
    }

    // MARK: - Tab Item (compact)

    private func tabItem(tab: Tab, icon: String, label: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 9, weight: .medium))
            }
            .foregroundStyle(selectedTab == tab ? ColorPalette.accent : .white.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 2)
        }
    }
}

typealias TabBarView = MainTabView
