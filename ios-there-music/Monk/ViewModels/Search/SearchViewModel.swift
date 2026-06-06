import Combine
import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = "" { didSet { search() } }
    @Published var results: [Track] = []
    @Published var history: [String] = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    let genres = [
        Genre(id: "pop", title: "Pop", symbolName: "music.mic", query: "pop hits"),
        Genre(id: "rock", title: "Rock", symbolName: "guitars", query: "rock"),
        Genre(id: "hiphop", title: "Hip-Hop", symbolName: "waveform", query: "hip hop"),
        Genre(id: "jazz", title: "Jazz", symbolName: "saxophone", query: "jazz"),
        Genre(id: "electronic", title: "Electronic", symbolName: "slider.horizontal.3", query: "electronic"),
        Genre(id: "soul", title: "Soul", symbolName: "heart.fill", query: "soul")
    ]
    private let repository = SearchRepository(api: ITunesAPIService())
    private var task: Task<Void, Never>?

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

    func commitSearch(_ value: String) { if !value.isEmpty { history.removeAll { $0 == value }; history.insert(value, at: 0); UserDefaults.standard.set(Array(history.prefix(12)), forKey: "searchHistory") } }
    func clearHistory() { history.removeAll(); UserDefaults.standard.removeObject(forKey: "searchHistory") }
}

final class GenreCategoryViewModel: ObservableObject {}
final class SearchResultViewModel: ObservableObject {}
