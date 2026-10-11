//
//  Location.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated struct Location: Sendable, Equatable {
    let name: String?
    let lat: Double
    let lon: Double
}
