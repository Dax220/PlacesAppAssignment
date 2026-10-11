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

    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return true
    }
}
