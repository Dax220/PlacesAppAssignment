//
//  LocationsModelTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
import Testing
@testable import PlacesApp

@MainActor
struct LocationsModelTests {
    
    private let amsterdam = Location(name: "Amsterdam", lat: 52.3547498, lon: 4.8339215)
    private let opener = FakeURLOpener()

    private func makeModel(
        _ results: Result<[Location], any Error>...
    ) -> (LocationsModel, FakeLocationsRepository) {
        let repository = FakeLocationsRepository(results: results)
        return (LocationsModel(repository: repository, opener: opener), repository)
    }

    @Test func startsInLoadingState() {
        let (model, _) = makeModel(.success([]))

        #expect(model.state == .loading)
    }

    @Test func showsLoadedLocations() async {
        let (model, _) = makeModel(.success([amsterdam]))

        await model.load()

        #expect(model.state == .loaded([amsterdam]))
    }

    @Test func showsFailureWhenFetchFails() async {
        let (model, _) = makeModel(.failure(TestError()))

        await model.load()

        #expect(model.state == .failed)
    }

    @Test func retryAfterFailureLoadsAgain() async {
        let (model, repository) = makeModel(.failure(TestError()), .success([amsterdam]))

        await model.load()
        #expect(model.state == .failed)

        await model.load()
        #expect(model.state == .loaded([amsterdam]))
        #expect(await repository.fetchCount == 2)
    }

    @Test func cancelledLoadDoesNotShowFailure() async {
        let (model, _) = makeModel(.failure(TestError()))

        let task = Task { await model.load() }
        task.cancel()
        await task.value

        #expect(model.state == .loading)
    }

    @Test func selectingLocationOpensWikipediaPlaces() async {
        let (model, _) = makeModel(.success([amsterdam]))

        await model.select(amsterdam)

        #expect(opener.openedURLs == [URL(string: "wikipedia://places?lat=52.3547498&lon=4.8339215")!])
    }
    
    @Test func selectingLocationWithWikipediaShowsNoAlert() async {
        let (model, _) = makeModel(.success([amsterdam]))

        await model.select(amsterdam)

        #expect(model.isWikipediaMissing == false)
    }

    @Test func selectingLocationWithoutWikipediaShowsAlert() async {
        let model = LocationsModel(
            repository: FakeLocationsRepository(results: [.success([amsterdam])]),
            opener: FakeURLOpener(canOpen: false)
        )

        await model.select(amsterdam)

        #expect(model.isWikipediaMissing)
    }
}
