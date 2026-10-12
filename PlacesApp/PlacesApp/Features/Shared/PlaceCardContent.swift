//
//  PlaceCardContent.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

struct PlaceCardContent: Equatable {
    let title: String
    let subtitle: String?
    let latitude: String
    let longitude: String

    var accessibilityLabel: String {
        guard let subtitle else { return title }
        return "\(title), \(subtitle)"
    }

    var accessibilityValue: String {
        String(localized: .placeCardAccessibilityValue(latitude, longitude))
    }
}

extension PlaceCardContent {
    
    /// The app is English-only, so numbers use the English format to match the text
    /// and VoiceOver reads them correctly in any region.
    init(location: Location, locale: Locale = Locale(identifier: "en")) {
        let name = location.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.init(
            title: name.isEmpty ? String(localized: .placeCardUnnamed) : name,
            subtitle: nil,
            latitude: Self.format(location.lat, locale: locale),
            longitude: Self.format(location.lon, locale: locale)
        )
    }

    init(result: PlaceSearchResult, locale: Locale = Locale(identifier: "en")) {
        let subtitle = result.subtitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.init(
            title: result.title,
            subtitle: subtitle.isEmpty ? nil : subtitle,
            latitude: Self.format(result.lat, locale: locale),
            longitude: Self.format(result.lon, locale: locale)
        )
    }

    static func format(_ coordinate: Double, locale: Locale) -> String {
        coordinate.formatted(.number.precision(.fractionLength(0...4)).locale(locale))
    }
}
