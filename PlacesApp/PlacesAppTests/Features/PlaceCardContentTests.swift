//
//  PlaceCardContentTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Testing
import Foundation
@testable import PlacesApp

@MainActor
struct PlaceCardContentTests {
    private let enUS = Locale(identifier: "en_US")
    private let amsterdam = Location(name: "Amsterdam", lat: 52.3547498, lon: 4.8339215)
    
    @Test func usesNameAsTitle() {
        let content = PlaceCardContent(location: amsterdam, locale: enUS)
        
        #expect(content.title == "Amsterdam")
    }
    
    @Test(arguments: [nil, "", "   "] as [String?])
    func fallsBackToUnnamedLocation(name: String?) {
        let content = PlaceCardContent(location: Location(name: name, lat: 1, lon: 2), locale: enUS)
        
        #expect(content.title == "Unnamed location")
    }
    
    @Test(
        arguments: [
            (Location(name: "", lat: 1,       lon: 2),       "1",      "2"),
            (Location(name: "", lat: 1.1,     lon: 2.1),     "1.1",    "2.1"),
            (Location(name: "", lat: 1.1234,  lon: 2.1234),  "1.1234", "2.1234"),
            (Location(name: "", lat: 1.12341, lon: 2.12341), "1.1234", "2.1234"),
        ]
    )
    func formatsCoordinatesWithPrecision(location: Location, lat: String, lon: String) {
        let content = PlaceCardContent(location: location, locale: enUS)
        
        #expect(content.latitude == lat)
        #expect(content.longitude == lon)
    }
    
    @Test(
        arguments: [
            (Location(name: "", lat: 1.11116, lon: 2.11116), "1.1112", "2.1112"),
            (Location(name: "", lat: 1.11114, lon: 2.11114), "1.1111", "2.1111"),
        ]
    )
    func roundsCoordinates(location: Location, lat: String, lon: String) {
        let content = PlaceCardContent(location: location, locale: enUS)
        
        #expect(content.latitude == lat)
        #expect(content.longitude == lon)
    }
    
    @Test func keepsSignOfNegativeCoordinates() {
        let location = Location(name: nil, lat: -12.3456789, lon: -21.7654321)
        let content = PlaceCardContent(location: location, locale: enUS)
        
        #expect(content.latitude == "-12.3457")
        #expect(content.longitude == "-21.7654")
    }
    
    @Test func usesLocaleDecimalSeparator() {
        let content = PlaceCardContent(location: amsterdam, locale: Locale(identifier: "nl_NL"))
        
        #expect(content.latitude == "52,3547")
    }
    
    @Test func describesPlaceForVoiceOver() {
        let content = PlaceCardContent(location: amsterdam, locale: enUS)
        
        #expect(content.accessibilityLabel == "Amsterdam")
        #expect(content.accessibilityValue == "Latitude 52.3547, longitude 4.8339")
    }
}
