//
//  LocationsRepository.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated protocol LocationsRepository: Sendable {
    func fetchLocations() async throws -> [Location]
}
