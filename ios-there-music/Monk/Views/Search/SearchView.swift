import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var player: PlayerManager
    @State private var searchText = ""

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Поиск")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .padding(.top, 8)

                    searchBar

                    if searchText.isEmpty {
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

    // MARK: - Genre Grid with Real Artwork

    private var genreGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Жанры")
                .font(.title3.bold())
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.genreCards) { card in
                    GenreArtworkCard(card: card) {
                        searchText = card.searchQuery
                        viewModel.query = card.searchQuery
                        viewModel.commitSearch(card.searchQuery)
                    }
                }
            }
        }
    }

    // MARK: - Search Results

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.results.isEmpty && !searchText.isEmpty {
                VStack(spacing: 16) {
                    Spacer().frame(height: 40)
                    ProgressView().tint(ColorPalette.accent)
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

// MARK: - Genre Card with Real Artwork from iTunes

struct GenreArtworkCard: View {
    let card: GenreCardData
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                // Real artwork background
                AsyncImage(url: card.artworkURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 100)
                            .clipped()
                    default:
                        // Fallback solid color
                        ColorPalette.elevated
                            .frame(height: 100)
                    }
                }

                // Dark overlay for text readability
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)

                // Genre icon
                Image(systemName: card.iconName)
                    .font(.system(size: 36))
                    .foregroundStyle(.white.opacity(0.25))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.trailing, 6)
                    .padding(.top, 4)

                // Genre title
                Text(card.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

typealias GenreCategoryGridView = SearchView
typealias SearchResultsView = SearchView
typealias SearchHistoryView = SearchView
typealias CategoryDetailView = SearchView
