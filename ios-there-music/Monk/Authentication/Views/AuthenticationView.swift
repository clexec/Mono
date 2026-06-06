import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var auth: AuthenticationManager
    @State private var route: AuthRoute?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black, ColorPalette.secondary.opacity(0.55), .black], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "waveform.circle.fill").font(.system(size: 78)).foregroundStyle(ColorPalette.accent)
                        Text(AppConstants.appName).font(.system(size: 38, weight: .black, design: .rounded)).foregroundStyle(.white)
                        Text(AppConstants.appDescription).font(.subheadline).multilineTextAlignment(.center).foregroundStyle(ColorPalette.textSecondary).padding(.horizontal, 28)
                    }
                    Spacer()
                    VStack(spacing: 12) {
                        Button { auth.signInWithApple() } label: { Label("Continue with Apple", systemImage: "apple.logo").thereButtonStyle() }
                        Button { Task { await auth.signInWithGoogle() } } label: { Label("Continue with Google", systemImage: "g.circle.fill").font(.headline).frame(maxWidth: .infinity, minHeight: 52).background(.white, in: Capsule()).foregroundStyle(.black) }
                        Button { route = .email } label: { Label("Sign in with Email", systemImage: "envelope.fill").font(.headline).frame(maxWidth: .infinity, minHeight: 52).modifier(LiquidGlassBackgroundModifier(cornerRadius: 26)).foregroundStyle(.white) }
                    }.padding(.horizontal)
                    HStack(spacing: 4) { Text("Terms of Service"); Text("•"); Text("Privacy Policy") }.font(.caption).foregroundStyle(ColorPalette.textSecondary)
                }.padding(.bottom, 28)
            }
            .alert("Authentication", isPresented: .constant(auth.errorMessage != nil)) { Button("OK") { auth.errorMessage = nil } } message: { Text(auth.errorMessage ?? "") }
            .navigationDestination(item: $route) { _ in LoginView() }
        }
    }
}

enum AuthRoute: Hashable, Identifiable { case email; var id: Int { 0 } }
