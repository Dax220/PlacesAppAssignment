//
//  FakePlaceSearchRepository.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

@testable import PlacesApp

actor FakePlaceSearchRepository: PlaceSearchRepository {
    
    private(set) var queries: [String] = []
    private var result: Result<[PlaceSearchResult], any Error>
    private var isSuspended = false
    private var suspendedSearches: [CheckedContinuation<Void, Never>] = []
    private var searchWaiters: [CheckedContinuation<Void, Never>] = []

    init(result: Result<[PlaceSearchResult], any Error> = .success([])) {
        self.result = result
    }

    func setResult(_ result: Result<[PlaceSearchResult], any Error>) {
        self.result = result
    }

    func suspend() {
        isSuspended = true
    }

    func resume() {
        isSuspended = false
        suspendedSearches.forEach { $0.resume() }
        suspendedSearches.removeAll()
    }

    func waitForSearch() async {
        guard queries.isEmpty else { return }
        await withCheckedContinuation { searchWaiters.append($0) }
    }

    func search(_ query: String) async throws -> [PlaceSearchResult] {
        queries.append(query)
        searchWaiters.forEach { $0.resume() }
        searchWaiters.removeAll()
        if isSuspended {
            await withCheckedContinuation { suspendedSearches.append($0) }
        }
        return try result.get()
    }
}
