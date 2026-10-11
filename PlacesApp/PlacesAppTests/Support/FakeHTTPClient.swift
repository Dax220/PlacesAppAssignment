//
//  FakeHTTPClient.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
@testable import PlacesApp

struct FakeHTTPClient: HTTPClient {
    
    private let result: Result<(Data, URLResponse), any Error>

    init(result: Result<(Data, URLResponse), any Error>) {
        self.result = result
    }

    init(data: Data, statusCode: Int = 200) {
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        self.init(result: .success((data, response)))
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try result.get()
    }
}
