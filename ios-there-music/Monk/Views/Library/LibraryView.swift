import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var library: LibraryManager
    @EnvironmentObject private var player: PlayerManager
    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: 18) { Text("Your Library").font(.largeTitle.bold()).foregroundStyle(.white); filters; liked; playlists; artists }.padding().padding(.bottom, 120) }.background(Color.black.ignoresSafeArea())
    }
    private var filters: some View { ScrollView(.horizontal, showsIndicators: false) { HStack { ForEach(LibraryFilter.allCases) { Text($0.rawValue).font(.subheadline.bold()).padding(.horizontal, 16).padding(.vertical, 9).modifier(LiquidGlassBackgroundModifier(cornerRadius: 18)).foregroundStyle(.white) } } } }
    private var liked: some View { VStack(alignment: .leading, spacing: 10) { Text("Liked Songs").font(.title2.bold()).foregroundStyle(.white); ForEach(library.likedTracks) { track in TrackRowView(track: track) { player.play(track, queue: library.likedTracks) } }; if library.likedTracks.isEmpty { Text("Like tracks from the player to build your collection.").foregroundStyle(ColorPalette.textSecondary).thereCard() } } }
    private var playlists: some View { VStack(alignment: .leading) { Text("My Playlists").font(.title2.bold()).foregroundStyle(.white); AlbumCardView(title: "THERE Favorites", subtitle: "Auto playlist", artworkURL: library.likedTracks.first?.artworkURL) } }
    private var artists: some View { VStack(alignment: .leading) { Text("Following Artists").font(.title2.bold()).foregroundStyle(.white); Text("Artists appear here after you follow them.").foregroundStyle(ColorPalette.textSecondary).thereCard() } }
}

typealias PlaylistsView = LibraryView
typealias LikedSongsView = LibraryView
typealias SavedAlbumsView = LibraryView
typealias FollowingArtistsView = LibraryView
typealias LibraryFiltersView = LibraryView
