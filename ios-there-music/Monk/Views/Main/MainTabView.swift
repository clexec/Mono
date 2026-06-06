import SwiftUI

struct MainTabView: View {
    @State private var showSearch = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Native TabView with Tab API — gets AUTOMATIC Liquid Glass on iOS 26
            #if compiler(>=6.2)
            nativeTabView
            #else
            fallbackTabView
            #endif

            // Floating search button — sits on the right side above the tab bar
            searchButton
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
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

    // MARK: - Fallback TabView for Xcode 16 builds

    private var fallbackTabView: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .tabItem { Label("Главная", systemImage: "house.fill") }
            }
            NavigationStack {
                LibraryView()
                    .tabItem { Label("Избранное", systemImage: "heart.fill") }
            }
            NavigationStack {
                CreatePlaylistView()
                    .tabItem { Label("Создать", systemImage: "plus") }
            }
            NavigationStack {
                ProfileView()
                    .tabItem { Label("Профиль", systemImage: "person.fill") }
            }
        }
    }

    // MARK: - Floating Search Button (Liquid Glass)

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
