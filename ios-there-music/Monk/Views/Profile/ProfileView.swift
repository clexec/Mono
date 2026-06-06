import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var auth: AuthenticationManager
    var body: some View { VStack(spacing: 18) { Image(systemName: "person.crop.circle.fill").font(.system(size: 92)).foregroundStyle(ColorPalette.accent); Text(auth.currentUser?.displayName ?? "Listener").font(.title.bold()).foregroundStyle(.white); Text(auth.currentUser?.email ?? "").foregroundStyle(ColorPalette.textSecondary); NavigationLink("Settings") { SettingsView() }.thereButtonStyle(); Button("Sign out") { auth.signOut() }.foregroundStyle(.red); Spacer() }.padding().background(Color.black.ignoresSafeArea()) }
}

typealias UserSettingsView = ProfileView
typealias LogoutView = ProfileView
