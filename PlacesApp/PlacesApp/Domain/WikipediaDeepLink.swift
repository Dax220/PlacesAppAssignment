//
//  WikipediaDeepLink.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated enum WikipediaDeepLink {
    
    static let scheme = "wikipedia"
    static let placesHost = "places"

    static func places(lat: Double, lon: Double) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = placesHost
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
        ]
        return components.url!
    }
}
