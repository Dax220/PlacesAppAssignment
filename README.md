
# Places Assignment

Two apps:
- **PlacesApp** — SwiftUI app that lists locations and opens them in Wikipedia.
- **wikipedia-ios** — fork of the Wikipedia app (git submodule), modified to open a given location in Places.

## Getting started

    git clone --recurse-submodules https://github.com/Dax220/PlacesAppAssignment.git

## Wikipedia changes

All changes: [compare with upstream](https://github.com/Dax220/wikipedia-ios/compare/main...places-deeplink)
  
- **Running on a device:** follow the [original setup instructions](https://github.com/wikimedia/wikipedia-ios#building-and-running)
  (run `./scripts/setup` in `wikipedia-ios` and enter your team ID when asked).  
- **Opens on the Places tab at launch**, as the assignment requires (`launchTab` in `WMFAppViewController`).
- **Deep link with coordinates:** `wikipedia://places?lat=52.3676&lon=4.9041` opens Places centered on the given location
  instead of the current one. Missing or invalid coordinates fall back to the regular Places tab.
  Covered by unit tests: [`NSUserActivityPlacesCoordinateTests`](https://github.com/Dax220/wikipedia-ios/blob/places-deeplink/WikipediaUnitTests/Code/NSUserActivityPlacesCoordinateTests.swift).
