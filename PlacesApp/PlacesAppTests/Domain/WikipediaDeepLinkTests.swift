//
//  WikipediaDeepLinkTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Testing
import Foundation
@testable import PlacesApp

struct WikipediaDeepLinkTests {
    
    @Test(arguments: [
        (12.3456789, 123.4567898, "wikipedia://places?lat=12.3456789&lon=123.4567898"),
        (-12.3456789, -123.4567898, "wikipedia://places?lat=-12.3456789&lon=-123.4567898"),
    ])
    func buildsPlacesURLWithCoordinates(lat: Double, lon: Double, expectedLink: String) {
        let url = WikipediaDeepLink.places(lat: lat, lon: lon)
        
        #expect(url.absoluteString == expectedLink)
    }
}
