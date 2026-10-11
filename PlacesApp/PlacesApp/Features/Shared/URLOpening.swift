//
//  URLOpening.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

protocol URLOpening {
    func open(_ url: URL) async -> Bool
}
