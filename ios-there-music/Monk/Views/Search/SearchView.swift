import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var player: PlayerManager
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: 18) { Text("Search").font(.largeTitle.bold()).foregroundStyle(.white); TextField("What do you want to listen to?", text: $viewModel.query).padding(13).background(.white, in: RoundedRectangle(cornerRadius: 10)).foregroundStyle(.black).onSubmit { viewModel.commitSearch(viewModel.query) }
            if viewModel.results.isEmpty { genres } else { results }
        }.padding().padding(.bottom, 120) }.background(Color.black.ignoresSafeArea())
    }
    private var genres: some View { LazyVGrid(columns: columns, spacing: 12) { ForEach(viewModel.genres) { genre in Button { viewModel.query = genre.query } label: { HStack { Text(genre.title).font(.headline); Spacer(); Image(systemName: genre.symbolName) }.foregroundStyle(.white).padding().frame(height: 94).background(ColorPalette.secondary.opacity(0.85), in: RoundedRectangle(cornerRadius: 14)) } } } }
    private var results: some View { VStack(alignment: .leading) { Text("Top results").font(.title2.bold()).foregroundStyle(.white); ForEach(viewModel.results) { track in TrackRowView(track: track) { player.play(track, queue: viewModel.results) } } } }
}

typealias GenreCategoryGridView = SearchView
typealias SearchResultsView = SearchView
typealias SearchHistoryView = SearchView
typealias CategoryDetailView = SearchView
