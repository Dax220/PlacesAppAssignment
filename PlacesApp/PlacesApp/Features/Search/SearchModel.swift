//
//  SearchModel.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
import Observation

@Observable
final class SearchModel {
    
    enum State: Equatable {
        case idle
        case searching
        case failed
        case noResults
        case results([PlaceSearchResult])
    }

    var isWikipediaMissing = false

    private(set) var state: State = .idle

    var query = "" {
        didSet {
            guard query != oldValue else { return }
            startSearch(after: debounce)
        }
    }

    @ObservationIgnored private(set) var searchTask: Task<Void, Never>?

    private let repository: any PlaceSearchRepository
    private let opener: any URLOpening
    private let debounce: Duration

    init(
        repository: any PlaceSearchRepository,
        opener: any URLOpening,
        debounce: Duration = .milliseconds(300)
    ) {
        self.repository = repository
        self.opener = opener
        self.debounce = debounce
    }

    deinit {
        searchTask?.cancel()
    }

    func retry() {
        startSearch(after: .zero)
    }

    func select(_ result: PlaceSearchResult) async {
        let url = WikipediaDeepLink.places(lat: result.lat, lon: result.lon)
        isWikipediaMissing = !(await opener.open(url))
    }

    private func startSearch(after delay: Duration) {
        searchTask?.cancel()
        searchTask = nil

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            state = .idle
            return
        }

        searchTask = Task { [weak self, repository] in
            do {
                try await Task.sleep(for: delay)
                
                try Task.checkCancellation()
                self?.state = .searching
                let results = try await repository.search(trimmedQuery)
                
                try Task.checkCancellation()
                self?.state = results.isEmpty ? .noResults : .results(results)
            } catch {
                guard !Task.isCancelled else { return }
                self?.state = .failed
            }
        }
    }
}
