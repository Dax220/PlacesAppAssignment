//
//  SearchModelTests.swift
//  PlacesAppTests
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation
import Testing
@testable import PlacesApp

@MainActor
struct SearchModelTests {
    
    private let rijksmuseum = PlaceSearchResult(
        title: "Rijksmuseum",
        subtitle: "Museumstraat 1, 1071 XX Amsterdam, Netherlands",
        lat: 52.359827,
        lon: 4.8850165
    )
    private let opener = FakeURLOpener()

    private func makeModel(
        _ result: Result<[PlaceSearchResult], any Error> = .success([])
    ) -> (SearchModel, FakePlaceSearchRepository) {
        let repository = FakePlaceSearchRepository(result: result)
        return (SearchModel(repository: repository, opener: opener, debounce: .zero), repository)
    }

    @Test func startsIdle() {
        let (model, _) = makeModel()

        #expect(model.state == .idle)
    }

    @Test(arguments: ["", "   ", "\n"])
    func blankQueryStaysIdleWithoutRequest(query: String) async {
        let (model, repository) = makeModel(.success([rijksmuseum]))

        model.query = query
        await model.searchTask?.value

        #expect(model.state == .idle)
        #expect(await repository.queries.isEmpty)
    }

    @Test func showsResultsForTrimmedQuery() async {
        let (model, repository) = makeModel(.success([rijksmuseum]))

        model.query = "  Rijks  "
        await model.searchTask?.value

        #expect(model.state == .results([rijksmuseum]))
        #expect(await repository.queries == ["Rijks"])
    }

    @Test func showsNoResults() async {
        let (model, _) = makeModel(.success([]))

        model.query = "zzzxqqq"
        await model.searchTask?.value

        #expect(model.state == .noResults)
    }

    @Test func showsFailure() async {
        let (model, _) = makeModel(.failure(TestError()))

        model.query = "Rijks"
        await model.searchTask?.value

        #expect(model.state == .failed)
    }

    @Test func showsSearchingWhileRequestIsInFlight() async {
        let (model, repository) = makeModel(.success([rijksmuseum]))
        await repository.suspend()

        model.query = "Rijks"
        await repository.waitForSearch()

        #expect(model.state == .searching)

        await repository.resume()
        await model.searchTask?.value
        #expect(model.state == .results([rijksmuseum]))
    }

    @Test func retryRepeatsCurrentQuery() async {
        let (model, repository) = makeModel(.failure(TestError()))
        model.query = "Rijks"
        await model.searchTask?.value
        #expect(model.state == .failed)

        await repository.setResult(.success([rijksmuseum]))
        model.retry()
        await model.searchTask?.value

        #expect(model.state == .results([rijksmuseum]))
        #expect(await repository.queries == ["Rijks", "Rijks"])
    }

    @Test func fastTypingSearchesOnlyLastQuery() async {
        let (model, repository) = makeModel(.success([rijksmuseum]))

        model.query = "R"
        model.query = "Ri"
        model.query = "Rij"
        await model.searchTask?.value

        #expect(await repository.queries == ["Rij"])
    }

    @Test func clearingQueryCancelsInFlightSearch() async {
        let (model, repository) = makeModel(.success([rijksmuseum]))
        await repository.suspend()
        model.query = "Rijks"
        await repository.waitForSearch()
        let inFlightSearch = model.searchTask

        model.query = ""
        #expect(model.state == .idle)

        await repository.resume()
        await inFlightSearch?.value
        
        #expect(inFlightSearch?.isCancelled == true)
        #expect(model.state == .idle)
    }

    @Test func selectingResultOpensWikipediaPlaces() async {
        let (model, _) = makeModel()

        await model.select(rijksmuseum)

        #expect(opener.openedURLs == [URL(string: "wikipedia://places?lat=52.359827&lon=4.8850165")!])
        #expect(model.isWikipediaMissing == false)
    }

    @Test func selectingResultWithoutWikipediaShowsAlert() async {
        let model = SearchModel(
            repository: FakePlaceSearchRepository(),
            opener: FakeURLOpener(canOpen: false),
            debounce: .zero
        )

        await model.select(rijksmuseum)

        #expect(model.isWikipediaMissing)
    }
    
    @Test func pastedCoordinatesShowCustomLocationWithoutSearch() async {
        let (model, repository) = makeModel(.success([rijksmuseum]))
        
        model.query = "52.3676, 4.9041"
        await model.searchTask?.value
        
        #expect(model.state == .results([
            PlaceSearchResult(title: "Custom location", subtitle: nil, lat: 52.3676, lon: 4.9041),
        ]))
        #expect(await repository.queries.isEmpty)
    }
    
    @Test func pastedCoordinatesCancelRunningSearch() async {
        let (model, repository) = makeModel(.success([rijksmuseum]))
        await repository.suspend()
        model.query = "52.3"
        await repository.waitForSearch()
        let inFlightSearch = model.searchTask
        
        model.query = "52.3676, 4.9041"
        await repository.resume()
        await inFlightSearch?.value
        
        #expect(inFlightSearch?.isCancelled == true)
        #expect(model.state == .results([
            PlaceSearchResult(title: "Custom location", subtitle: nil, lat: 52.3676, lon: 4.9041),
        ]))
    }
}
