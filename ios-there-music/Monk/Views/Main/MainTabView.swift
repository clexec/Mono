import SwiftUI

struct MainTabView: View {
    @State private var showSearch = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            #if compiler(>=6.2)
            // Native iOS 26 TabView with Tab — automatically gets Liquid Glass
            nativeTabView
            #else
            // Fallback for Xcode 16 builds — custom tab bar with ultraThinMaterial
            customTabView
            #endif

            // Floating search button with Liquid Glass
            searchButton
        }
        .sheet(isPresented: $showSearch) {
            NavigationStack {
                SearchView()
            }
        }
    }

    // MARK: - Native iOS 26 TabView (automatic Liquid Glass)

    #if compiler(>=6.2)
    @ViewBuilder
    private var nativeTabView: some View {
        TabView {
            Tab("Главная", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }

            Tab("Избранное", systemImage: "heart.fill") {
                NavigationStack {
                    LibraryView()
                }
            }

            Tab("Создать", systemImage: "plus") {
                NavigationStack {
                    CreatePlaylistView()
                }
            }

            Tab("Профиль", systemImage: "person.fill") {
                NavigationStack {
                    ProfileView()
                }
            }
        }
    }
    #endif

    // MARK: - Fallback custom tab view (Xcode 16)

    private var customTabView: some View {
        let selectedTab = Binding<TabFallback>(
            get: { .home },
            set: { _ in }
        )
        return NavigationStack {
            ZStack(alignment: .bottom) {
                HomeView()
                    .padding(.bottom, 100)

                VStack(spacing: 6) {
                    MiniPlayerView()
                    HStack(spacing: 0) {
                        tabItemFallback(icon: "house.fill", label: "Главная")
                        tabItemFallback(icon: "heart.fill", label: "Избранное")
                        tabItemFallback(icon: "plus", label: "Создать")
                        tabItemFallback(icon: "person.fill", label: "Профиль")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 6)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func tabItemFallback(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18))
            Text(label)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundStyle(.white.opacity(0.7))
        .frame(maxWidth: .infinity)
    }

    // MARK: - Floating Search Button

    private var searchButton: some View {
        Button {
            showSearch = true
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
        }
        #if compiler(>=6.2)
        .glassEffect(in: .rect(cornerRadius: 25))
        #else
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
        #endif
        .padding(.trailing, 16)
        .padding(.bottom, 72)
    }
}

// Fallback enum for Xcode 16 builds
private enum TabFallback: Int, CaseIterable {
    case home, favorites, create, profile
}

typealias TabBarView = MainTabView
