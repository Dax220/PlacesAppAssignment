//
//  NetworkError.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

nonisolated enum NetworkError: Error, Equatable {
    case badStatus(Int)
    case decodingFailed
}
