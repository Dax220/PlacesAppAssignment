//
//  FakeURLOpener.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
@testable import PlacesApp

final class FakeURLOpener: URLOpening {
    
    private(set) var openedURLs: [URL] = []
    private let canOpen: Bool

    init(canOpen: Bool = true) {
        self.canOpen = canOpen
    }

    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return canOpen
    }
}
