import Combine
import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = "" { didSet { search() } }
    @Published var results: [Track] = []
    @Published var history: [String] = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    @Published var genreCards: [GenreCardData] = []

    private let repository = SearchRepository(api: ITunesAPIService())
    private var task: Task<Void, Never>?

    init() {
        genreCards = GenreCardData.defaultCards
        loadGenreArtwork()
    }

    func search() {
        task?.cancel()
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { results = []; return }
        task = Task { [repository] in
            try? await Task.sleep(for: .milliseconds(300))
            let tracks = await repository.search(text)
            if !Task.isCancelled { await MainActor.run { self.results = tracks } }
        }
    }

    func commitSearch(_ value: String) {
        if !value.isEmpty {
            history.removeAll { $0 == value }
            history.insert(value, at: 0)
            UserDefaults.standard.set(Array(history.prefix(12)), forKey: "searchHistory")
        }
    }

    func clearHistory() {
        history.removeAll()
        UserDefaults.standard.removeObject(forKey: "searchHistory")
    }

    private func loadGenreArtwork() {
        Task {
            let api = ITunesAPIService()
            for index in genreCards.indices {
                do {
                    let tracks = try await api.search(term: genreCards[index].searchQuery, limit: 5)
                    if let artwork = tracks.first?.artworkURL {
                        await MainActor.run { genreCards[index].artworkURL = artwork }
                    }
                } catch { continue }
            }
        }
    }
}

// Genre card data with real artwork URLs
struct GenreCardData: Identifiable {
    let id: String
    let title: String
    let iconName: String
    let searchQuery: String
    let gradient: [Color]
    var artworkURL: URL?

    static let defaultCards: [GenreCardData] = [
        GenreCardData(id: "pop", title: "Pop", iconName: "music.mic", searchQuery: "pop hits", gradient: [Color.pink.opacity(0.8), Color.purple.opacity(0.6)]),
        GenreCardData(id: "rock", title: "Rock", iconName: "guitars", searchQuery: "rock", gradient: [Color.red.opacity(0.8), Color.orange.opacity(0.6)]),
        GenreCardData(id: "hiphop", title: "Hip-Hop", iconName: "waveform", searchQuery: "hip hop", gradient: [Color.yellow.opacity(0.7), Color.red.opacity(0.6)]),
        GenreCardData(id: "jazz", title: "Jazz", iconName: "saxophone", searchQuery: "jazz", gradient: [Color.blue.opacity(0.7), Color.indigo.opacity(0.5)]),
        GenreCardData(id: "electronic", title: "Electronic", iconName: "slider.horizontal.3", searchQuery: "electronic", gradient: [Color.cyan.opacity(0.7), Color.purple.opacity(0.6)]),
        GenreCardData(id: "soul", title: "Soul", iconName: "heart.fill", searchQuery: "soul", gradient: [Color.orange.opacity(0.7), Color.pink.opacity(0.5)]),
        GenreCardData(id: "rnb", title: "R&B", iconName: "music.note.list", searchQuery: "r&b", gradient: [Color.purple.opacity(0.7), Color.blue.opacity(0.5)]),
        GenreCardData(id: "classical", title: "Classical", iconName: "pianokeys", searchQuery: "classical", gradient: [Color.green.opacity(0.6), Color.teal.opacity(0.5)])
    ]
}

final class GenreCategoryViewModel: ObservableObject {}
final class SearchResultViewModel: ObservableObject {}
