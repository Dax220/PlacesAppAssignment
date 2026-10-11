//
//  PlaceCardContent.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

struct PlaceCardContent: Equatable {
    let title: String
    let latitude: String
    let longitude: String

    var accessibilityLabel: String { title }

    var accessibilityValue: String {
        String(localized: "Latitude \(latitude), longitude \(longitude)")
    }
}

extension PlaceCardContent {
    
    init(location: Location, locale: Locale = .current) {
        let name = location.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.init(
            title: name.isEmpty ? String(localized: "Unnamed location") : name,
            latitude: Self.format(location.lat, locale: locale),
            longitude: Self.format(location.lon, locale: locale)
        )
    }

    static func format(_ coordinate: Double, locale: Locale) -> String {
        coordinate.formatted(.number.precision(.fractionLength(0...4)).locale(locale))
    }
}
