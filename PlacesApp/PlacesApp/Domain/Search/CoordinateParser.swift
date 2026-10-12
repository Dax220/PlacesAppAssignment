//
//  CoordinateParser.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 12.10.2026.
//

import Foundation

nonisolated enum CoordinateParser {
    
    static func parse(_ text: String) -> (lat: Double, lon: Double)? {
        guard let match = text.wholeMatch(of: /\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*/),
              let lat = Double(match.1),
              let lon = Double(match.2),
              (-90...90).contains(lat),
              (-180...180).contains(lon) else {
            return nil
        }
        return (lat, lon)
    }
}
