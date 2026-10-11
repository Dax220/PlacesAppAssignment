//
//  CoordinateParserTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 12.10.2026.
//

import Testing
@testable import PlacesApp

struct CoordinateParserTests {
    @Test(arguments: [
        ("52.3676, 4.9041", 52.3676, 4.9041),
        ("52.3676,4.9041", 52.3676, 4.9041),
        ("  -33.8688 , 151.2093  ", -33.8688, 151.2093),
        ("90, -180", 90, -180),
        ("52, 4", 52, 4),
    ])
    func parsesLatitudeCommaLongitude(text: String, lat: Double, lon: Double) throws {
        let coordinate = try #require(CoordinateParser.parse(text))

        #expect(coordinate.lat == lat)
        #expect(coordinate.lon == lon)
    }

    @Test(arguments: [
        "Amsterdam",
        "52.3676",
        "52.3676 4.9041",
        "52,3676, 4,9041",
        "91, 0",
        "0, 181",
        "1, 2, 3",
        "Route 66, 1",
    ])
    func treatsAnythingElseAsPlaceName(text: String) {
        #expect(CoordinateParser.parse(text) == nil)
    }
}
