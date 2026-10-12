//
//  HTTPClientTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
import Testing
@testable import PlacesApp

struct HTTPClientTests {
    
    private struct Payload: Decodable, Sendable, Equatable {
        let value: Int
    }

    private let request = URLRequest(url: URL(string: "https://example.com")!)
    private let validBody = Data(#"{"value": 42}"#.utf8)

    @Test func decodesBodyOn2xx() async throws {
        let client = FakeHTTPClient(data: validBody)

        let payload: Payload = try await client.get(request)

        #expect(payload == Payload(value: 42))
    }

    @Test(arguments: [199, 300, 404, 500])
    func throwsStatusOutside2xx(statusCode: Int) async {
        let client = FakeHTTPClient(data: validBody, statusCode: statusCode)

        await #expect(throws: NetworkError.badStatus(statusCode)) {
            let _: Payload = try await client.get(request)
        }
    }

    @Test func throwsDecodingFailedForMalformedBody() async {
        let client = FakeHTTPClient(data: Data("<html>Service Unavailable</html>".utf8))

        await #expect(throws: NetworkError.decodingFailed) {
            let _: Payload = try await client.get(request)
        }
    }

    @Test func rethrowsTransportErrors() async {
        let client = FakeHTTPClient(result: .failure(URLError(.notConnectedToInternet)))

        await #expect(throws: URLError(.notConnectedToInternet)) {
            let _: Payload = try await client.get(request)
        }
    }
}
