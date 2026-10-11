//
//  RemoteLocationsRepositoryTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
import Testing
@testable import PlacesApp

struct RemoteLocationsRepositoryTests {
    
    private let testUrl = URL(string: "https://example.com")!
    
    @Test func mapsFeedToLocations() async throws {
        let client = FakeHTTPClient(data: Fixtures.locationsJSONData)
        let repository = RemoteLocationsRepository(client: client, url: testUrl)

        let locations = try await repository.fetchLocations()

        #expect(locations == [
            Location(name: "Amsterdam", lat: 52.3547498, lon: 4.8339215),
            Location(name: "Mumbai", lat: 19.0823998, lon: 72.8111468),
            Location(name: "Copenhagen", lat: 55.6713442, lon: 12.523785),
            Location(name: nil, lat: 40.4380638, lon: -3.7495758),
        ])
    }

    @Test func propagatesNetworkErrors() async {
        let client = FakeHTTPClient(data: Data(), statusCode: 503)
        let repository = RemoteLocationsRepository(client: client, url: testUrl)

        await #expect(throws: NetworkError.badStatus(503)) {
            try await repository.fetchLocations()
        }
    }
}
