//
//  LocationsResponseDTO.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated struct LocationsResponseDTO: Decodable, Sendable {
    let locations: [LocationDTO]
}

nonisolated struct LocationDTO: Decodable, Sendable {
    
    let name: String?
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case name, lat
        case lon = "long"
    }

    var location: Location {
        Location(name: name, lat: lat, lon: lon)
    }
}
