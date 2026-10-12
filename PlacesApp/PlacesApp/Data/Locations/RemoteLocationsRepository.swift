//
//  RemoteLocationsRepository.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated struct RemoteLocationsRepository: LocationsRepository {
    
    private let client: any HTTPClient
    private let url: URL

    init(client: any HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }

    func fetchLocations() async throws -> [Location] {
        let response: LocationsResponseDTO = try await client.get(URLRequest(url: url))
        var seen = Set<Location>()
        return response.locations.map(\.location).filter { seen.insert($0).inserted }
    }
}
