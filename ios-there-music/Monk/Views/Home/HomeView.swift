import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var player: PlayerManager
    @EnvironmentObject private var persistence: PersistenceController

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                header
                section("Discover Weekly", tracks: viewModel.discoverWeekly)
                section("Release Radar", tracks: viewModel.releaseRadar)
                playlists
                section("Recently Played", tracks: persistence.recentlyPlayed)
                section("Popular now", tracks: viewModel.popular)
            }.padding(.horizontal).padding(.bottom, 120)
        }.background(Color.black.ignoresSafeArea()).task { await viewModel.load() }
    }

    private var header: some View { HStack { Text("Good evening").font(.largeTitle.bold()).foregroundStyle(.white); Spacer(); NavigationLink { ProfileView() } label: { Image(systemName: "person.crop.circle.fill").font(.title).foregroundStyle(ColorPalette.accent) } } }
    private func section(_ title: String, tracks: [Track]) -> some View { VStack(alignment: .leading, spacing: 12) { Text(title).font(.title2.bold()).foregroundStyle(.white); ScrollView(.horizontal, showsIndicators: false) { HStack(spacing: 14) { ForEach(tracks) { track in AlbumCardView(title: track.title, subtitle: track.artistName, artworkURL: track.artworkURL).onTapGesture { player.play(track, queue: tracks.filter { $0.id != track.id }) } } } } } }
    private var playlists: some View { VStack(alignment: .leading, spacing: 12) { Text("Daily Mixes").font(.title2.bold()).foregroundStyle(.white); ScrollView(.horizontal, showsIndicators: false) { HStack(spacing: 14) { ForEach(viewModel.dailyMixes) { list in PlaylistCardView(title: list.title, subtitle: list.subtitle, artworkURL: list.artworkURL) } } } } }
}

typealias DiscoverWeeklyView = HomeView
typealias ReleaseRadarView = HomeView
typealias DailyMixView = HomeView
typealias RecentlyPlayedView = HomeView
struct RecommendationCardView: View { let track: Track; var body: some View { AlbumCardView(title: track.title, subtitle: track.artistName, artworkURL: track.artworkURL) } }
