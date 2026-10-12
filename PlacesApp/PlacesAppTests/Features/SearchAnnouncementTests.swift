//
//  SearchAnnouncementTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 12.10.2026.
//

import Foundation
import Testing
@testable import PlacesApp

struct SearchAnnouncementTests {

    @Test(arguments: [
        (1, "1 result"),
        (2, "2 results"),
        (0, "0 results"),
    ])
    func pluralizesResultCount(count: Int, expected: String) {
        var resource = LocalizedStringResource.searchAnnouncementResults(count)
        resource.locale = Locale(identifier: "en")

        #expect(String(localized: resource) == expected)
    }
}
