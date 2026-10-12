//
//  Location.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated struct Location: Sendable, Hashable {
    let name: String?
    let lat: Double
    let lon: Double
}
