//
//  FakeLocationsRepository.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

@testable import PlacesApp

actor FakeLocationsRepository: LocationsRepository {
    
    private var results: [Result<[Location], any Error>]
    private(set) var fetchCount = 0

    init(results: [Result<[Location], any Error>]) {
        precondition(!results.isEmpty, "Provide at least one result")
        self.results = results
    }

    func fetchLocations() async throws -> [Location] {
        fetchCount += 1
        let result = results.count > 1 ? results.removeFirst() : results[0]
        return try result.get()
    }
}
