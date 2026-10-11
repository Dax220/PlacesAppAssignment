//
//  LocationsModel.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
import Observation

@Observable
final class LocationsModel {
    
    enum State: Equatable {
        case loading
        case failed
        case loaded([Location])
    }

    var isWikipediaMissing = false
    
    private(set) var state: State = .loading

    private let repository: any LocationsRepository
    private let opener: any URLOpening

    init(
        repository: any LocationsRepository,
        opener: any URLOpening
    ) {
        self.repository = repository
        self.opener = opener
    }

    func load() async {
        state = .loading
        do {
            state = .loaded(try await repository.fetchLocations())
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed
        }
    }

    func select(_ location: Location) async {
        let url = WikipediaDeepLink.places(lat: location.lat, lon: location.lon)
        isWikipediaMissing = !(await opener.open(url))
    }
}
