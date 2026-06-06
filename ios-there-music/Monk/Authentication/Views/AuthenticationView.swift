import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var auth: AuthenticationManager
    @State private var route: AuthRoute?
    @State private var backgroundTracks: [Track] = []

    var body: some View {
        NavigationStack {
            ZStack {
                // Moving album covers background
                albumGridBackground

                // Dark overlay
                LinearGradient(
                    colors: [.black.opacity(0.7), .black.opacity(0.5), .black.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Content
                VStack(spacing: 24) {
                    Spacer()

                    // Logo
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(ColorPalette.accent.opacity(0.15))
                                .frame(width: 80, height: 80)
                            Image(systemName: "waveform.circle.fill")
                                .font(.system(size: 56))
                                .foregroundStyle(ColorPalette.accent)
                        }
                        Text(AppConstants.appName)
                            .font(.system(size: 38, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        Text(AppConstants.appDescription)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(ColorPalette.textSecondary)
                            .padding(.horizontal, 28)
                    }

                    Spacer()

                    // Auth buttons
                    VStack(spacing: 12) {
                        Button {
                            auth.signInWithApple()
                        } label: {
                            Label("Войти через Apple", systemImage: "apple.logo")
                                .font(.headline)
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(.white, in: Capsule())
                                .foregroundStyle(.black)
                        }

                        Button {
                            route = .email
                        } label: {
                            Label("Регистрация по почте", systemImage: "envelope.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity, minHeight: 52)
                                #if compiler(>=6.2)
                                .glassEffect(in: .rect(cornerRadius: 26))
                                #else
                                .background(.ultraThinMaterial, in: Capsule())
                                #endif
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 24)

                    HStack(spacing: 4) {
                        Text("Условия использования")
                        Text("•")
                        Text("Политика конфиденциальности")
                    }
                    .font(.caption)
                    .foregroundStyle(ColorPalette.textSecondary)
                }
                .padding(.bottom, 28)
            }
            .alert("Ошибка", isPresented: .constant(auth.errorMessage != nil)) {
                Button("OK") { auth.errorMessage = nil }
            } message: {
                Text(auth.errorMessage ?? "")
            }
            .navigationDestination(item: $route) { _ in LoginView() }
        }
        .task {
            await loadBackgroundCovers()
        }
    }

    // MARK: - Moving Album Grid Background

    private var albumGridBackground: some View {
        GeometryReader { geo in
            let cols = Int(geo.size.width / 100) + 2
            let rows = Int(geo.size.height / 100) + 2

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(0..<max(cols, 4), id: \.self) { col in
                        VStack(spacing: 2) {
                            ForEach(0..<max(rows, 8), id: \.self) { row in
                                let index = (col * 10 + row) % max(backgroundTracks.count, 1)
                                if index < backgroundTracks.count {
                                    let track = backgroundTracks[index]
                                    AsyncImage(url: track.artworkURL) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        default:
                                            Rectangle().fill(ColorPalette.elevated)
                                        }
                                    }
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                } else {
                                    Rectangle()
                                        .fill(ColorPalette.elevated)
                                        .frame(width: 100, height: 100)
                                }
                            }
                        }
                    }
                }
            }
            .disabled(true)
            .opacity(0.6)
        }
        .ignoresSafeArea()
    }

    private func loadBackgroundCovers() async {
        let api = ITunesAPIService()
        do {
            let tracks = try await api.search(term: "top hits 2024", limit: 25)
            await MainActor.run { backgroundTracks = tracks }
        } catch {
            // Fallback: empty
        }
    }
}

enum AuthRoute: Hashable, Identifiable { case email; var id: Int { 0 } }
