//
//  PlaceSearchResult.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated struct PlaceSearchResult: Sendable, Hashable {
    let title: String
    let subtitle: String?
    let lat: Double
    let lon: Double
}
