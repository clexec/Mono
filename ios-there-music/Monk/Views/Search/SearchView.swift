import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var player: PlayerManager
    @State private var searchText = ""

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("Поиск")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .padding(.top, 8)

                    // Search bar
                    searchBar

                    // Recent searches or genre grid
                    if searchText.isEmpty {
                        recentSearches
                        genreGrid
                    } else {
                        searchResults
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 120)
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(ColorPalette.textSecondary)

            TextField("Что хочешь послушать?", text: $searchText)
                .font(.body)
                .foregroundStyle(.white)
                .tint(ColorPalette.accent)
                .onSubmit {
                    viewModel.query = searchText
                    viewModel.commitSearch(searchText)
                }
                .onChange(of: searchText) { _, newValue in
                    viewModel.query = newValue
                }

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    viewModel.query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(ColorPalette.textSecondary)
                }
            }
        }
        .padding(12)
        .background(ColorPalette.elevated.opacity(0.8), in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Recent Searches

    private var recentSearches: some View {
        Group {
            if !viewModel.history.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Недавние")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        Spacer()
                        Button("Очистить") {
                            viewModel.clearHistory()
                        }
                        .font(.subheadline)
                        .foregroundStyle(ColorPalette.accent)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.history.prefix(8), id: \.self) { term in
                                Button {
                                    searchText = term
                                    viewModel.query = term
                                    viewModel.commitSearch(term)
                                } label: {
                                    Text(term)
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(ColorPalette.elevated, in: Capsule())
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Genre Grid with Photos

    private var genreGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Жанры")
                .font(.title3.bold())
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.genres) { genre in
                    GenreCard(genre: genre) {
                        searchText = genre.query
                        viewModel.query = genre.query
                        viewModel.commitSearch(genre.query)
                    }
                }
            }
        }
    }

    // MARK: - Search Results

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.results.isEmpty && !searchText.isEmpty {
                // Loading or empty state
                VStack(spacing: 16) {
                    Spacer().frame(height: 40)
                    Image(systemName: "music.note.search")
                        .font(.system(size: 48))
                        .foregroundStyle(ColorPalette.textSecondary.opacity(0.5))
                    Text("Ищем музыку...")
                        .font(.title3)
                        .foregroundStyle(ColorPalette.textSecondary)
                }
                .frame(maxWidth: .infinity)
            } else {
                Text("Результаты")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                ForEach(viewModel.results) { track in
                    TrackRowView(track: track) {
                        player.play(track, queue: viewModel.results)
                    }
                }
            }
        }
    }
}

// MARK: - Genre Card with Background Image

struct GenreCard: View {
    let genre: Genre
    let action: () -> Void

    // Gradient colors for each genre — no images needed, pure SwiftUI
    private var gradientColors: [Color] {
        switch genre.id {
        case "pop":       return [Color.pink.opacity(0.8), Color.purple.opacity(0.6)]
        case "rock":      return [Color.red.opacity(0.8), Color.orange.opacity(0.6)]
        case "hiphop":    return [Color.yellow.opacity(0.7), Color.red.opacity(0.6)]
        case "jazz":      return [Color.blue.opacity(0.7), Color.indigo.opacity(0.5)]
        case "electronic":return [Color.cyan.opacity(0.7), Color.purple.opacity(0.6)]
        case "soul":      return [Color.orange.opacity(0.7), Color.pink.opacity(0.5)]
        default:          return [ColorPalette.secondary.opacity(0.85), ColorPalette.accent.opacity(0.4)]
        }
    }

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                // Background gradient
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 100)

                // Genre icon — large, semi-transparent
                Image(systemName: genre.symbolName)
                    .font(.system(size: 44))
                    .foregroundStyle(.white.opacity(0.25))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.trailing, 8)
                    .padding(.top, 4)

                // Genre title
                Text(genre.title)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

typealias GenreCategoryGridView = SearchView
typealias SearchResultsView = SearchView
typealias SearchHistoryView = SearchView
typealias CategoryDetailView = SearchView
