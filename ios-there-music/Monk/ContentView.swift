import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var auth: AuthenticationManager
    var body: some View {
        Group {
            if auth.currentUser == nil { AuthenticationView() } else { MainTabView() }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview { ContentView().environmentObject(AuthenticationManager(persistence: PersistenceController())).environmentObject(PlayerManager(persistence: PersistenceController())).environmentObject(LibraryManager(persistence: PersistenceController())).environmentObject(PersistenceController()).environmentObject(ThemeManager()).environmentObject(CacheManager()).environmentObject(NotificationManager()) }
