//
//  PlaceSearchRepository.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated protocol PlaceSearchRepository: Sendable {
    func search(_ query: String) async throws -> [PlaceSearchResult]
}
