import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var auth: AuthenticationManager
    @EnvironmentObject private var library: LibraryManager
    @EnvironmentObject private var persistence: PersistenceController
    @State private var showSettings = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Header with avatar and info
                VStack(spacing: 14) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [ColorPalette.accent.opacity(0.6), ColorPalette.secondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        if let user = auth.currentUser, !user.displayName.isEmpty {
                            Text(String(user.displayName.prefix(1)).uppercased())
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }

                    // Display name
                    Text(auth.currentUser?.displayName ?? "Слушатель")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    // Username / email
                    if let email = auth.currentUser?.email, !email.isEmpty {
                        Text("@\(email.components(separatedBy: "@").first ?? email)")
                            .font(.subheadline)
                            .foregroundStyle(ColorPalette.textSecondary)
                    }

                    // Stats row
                    HStack(spacing: 0) {
                        statItem(value: "\(library.likedTracks.count)", label: "Треков")
                        Rectangle()
                            .fill(ColorPalette.textSecondary.opacity(0.3))
                            .frame(width: 1, height: 36)
                        statItem(value: "\(persistence.recentlyPlayed.count)", label: "Прослушано")
                        Rectangle()
                            .fill(ColorPalette.textSecondary.opacity(0.3))
                            .frame(width: 1, height: 36)
                        statItem(value: "0", label: "Плейлистов")
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    #if compiler(>=6.2)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    #else
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    #endif
                }
                .padding(.top, 20)

                // Menu items
                VStack(spacing: 6) {
                    profileMenuItem(icon: "gearshape.fill", title: "Настройки", subtitle: "Тема, уведомления, кэш") {
                        showSettings = true
                    }
                    profileMenuItem(icon: "bell.fill", title: "Уведомления", subtitle: "Новые релизы, рекомендации") {}
                    profileMenuItem(icon: "headphones", title: "Качество звука", subtitle: "Стриминг, загрузки") {}
                    profileMenuItem(icon: "shield.fill", title: "Конфиденциальность", subtitle: "Данные, безопасность") {}
                    profileMenuItem(icon: "questionmark.circle.fill", title: "Помощь", subtitle: "FAQ, обратная связь") {}
                }
                .padding(.top, 20)

                // Sign out
                Button {
                    auth.signOut()
                } label: {
                    HStack {
                        Image(systemName: "arrow.right.square.fill")
                        Text("Выйти из аккаунта")
                    }
                    .font(.headline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.red.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(.top, 24)
                .padding(.bottom, 120)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.black.ignoresSafeArea())
        .sheet(isPresented: $showSettings) {
            NavigationStack { SettingsView() }
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(label)
                .font(.caption)
                .foregroundStyle(ColorPalette.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func profileMenuItem(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(ColorPalette.accent)
                    .frame(width: 40, height: 40)
                    .background(ColorPalette.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(ColorPalette.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ColorPalette.textSecondary.opacity(0.5))
            }
            .padding(12)
            .background(ColorPalette.elevated.opacity(0.5), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

typealias UserSettingsView = ProfileView
typealias LogoutView = ProfileView
