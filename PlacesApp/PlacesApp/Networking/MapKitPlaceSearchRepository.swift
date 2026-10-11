//
//  MapKitPlaceSearchRepository.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 12.10.2026.
//

import MapKit

nonisolated struct MapKitPlaceSearchRepository: PlaceSearchRepository {
    
    func search(_ query: String) async throws -> [PlaceSearchResult] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = [.address, .pointOfInterest]

        let items: [MKMapItem]
        do {
            items = try await MKLocalSearch(request: request).start().mapItems
        } catch let error as MKError where error.code == .placemarkNotFound {
            return []
        }

        return items.map { item in
            let address = item.placemark.title
            return PlaceSearchResult(
                title: item.name ?? "",
                subtitle: address == item.name ? nil : address,
                lat: item.placemark.coordinate.latitude,
                lon: item.placemark.coordinate.longitude
            )
        }
    }
}
