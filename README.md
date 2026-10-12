
# Places Assignment

Two apps:
- **PlacesApp** — SwiftUI app that lists locations and opens them in Wikipedia.
- **wikipedia-ios** — fork of the Wikipedia app (git submodule), modified to open a given location in Places.

## Getting started

    git clone --recurse-submodules https://github.com/Dax220/PlacesAppAssignment.git

Install the Wikipedia fork on the simulator or device first, then run PlacesApp on the same one.
Without Wikipedia, tapping a place shows an alert.

- **Running Wikipedia on a device:** follow the [original setup instructions](https://github.com/wikimedia/wikipedia-ios#building-and-running)
  (run `./scripts/setup` in `wikipedia-ios` and enter your team ID when asked).  
- **Running PlacesApp on a device:** create `Local.xcconfig` next to `Base.xcconfig` in `PlacesApp/Config/` with your team ID:
  ```
  DEVELOPMENT_TEAM = YOUR_TEAM_ID
  ```
  `Base.xcconfig` includes this file if it exists, and git ignores it, so the team ID stays out of the repository.  

## PlacesApp

Xcode 26 or later, iOS 17.6+.

- **Tests:** run with ⌘U in Xcode. Written with Swift Testing. Dependencies such as the HTTP client and repositories are replaced with fakes.

### What it does

- Loads places from `locations.json` and shows them as cards. Tapping a card opens Wikipedia Places at that point.
- The search field takes a place name or coordinates:
  - `52.3676, 4.9041` (latitude, longitude, dot as decimal separator) is parsed locally and shown as a single
    "Custom location" card right away: no request, works offline, the point is exact.
  - Anything else goes to MapKit search (`MKLocalSearch`) after a 300 ms debounce.
    A new keypress cancels the previous search.

### Assumptions

Decisions the assignment leaves open:
- **iOS 17.6+.** The Wikipedia fork requires iOS 17.6, so PlacesApp is no use on older versions.
- **Simple UI built from standard components** such as `ContentUnavailableView`, `GroupBox` and `LabeledContent`.
  The assignment has no design, and standard components support Dynamic Type, Dark Mode and VoiceOver out of the box.
  iOS 17 also brings `@Observable` and `ContentUnavailableView`, which the app is built on.
- **Custom location: coordinates or a place name.** The assignment doesn't say how the user enters a location.
  Wikipedia needs coordinates, so the user can paste them. Most people don't know coordinates, so the user can
  also type a place name, and the app finds it with MapKit.
- **Wikipedia isn't installed:** tapping a place shows an alert.
- **A place without a name** is shown as "Unnamed location".
- **English only for now.** All strings are in the string catalog, so a new language needs no code changes.

### Structure

```
PlacesApp/
  App/        entry point, AppDependencies (composition root), SystemURLOpener (the only UIKit code)
  Domain/     models, repository protocols, CoordinateParser, WikipediaDeepLink
  Data/       HTTP client, DTOs, repository implementations
  Features/   screens with their models, Shared for code used by both screens
```

Inside Domain, Data and Features, feature code is grouped into `Locations/` and `Search/`. Tests follow the same layout.

Models are `@Observable` and depend on protocols. Real implementations are created in `AppDependencies`, tests use fakes.

### Concurrency

- Swift 6 language mode, main actor by default. Domain and data types are `nonisolated` and `Sendable`.
- The app uses async/await. Each search is a `Task` that waits for the debounce with `Task.sleep` and then searches.
  A new query cancels the previous task, whether it is still waiting or already searching, so old results never
  replace newer ones. No timers or Combine needed.
- Async tests don't use sleeps. `FakePlaceSearchRepository` suspends a request on a `CheckedContinuation`
  until the test resumes it, so a test can check the state while the search is still running.

### Accessibility

- A card is one VoiceOver element: name and address as the label, coordinates as the value, "Opens in Wikipedia" as the hint.
- VoiceOver announces the number of search results ("1 result", "5 results").
- At accessibility text sizes a card puts coordinates under their labels (`AdaptiveLabeledContentStyle`).
- Coordinates on cards are formatted in English. With the Dutch region, VoiceOver read `52,3547` as two numbers
  (found on a device).

### Localization

Strings live in `Localizable.xcstrings` under keys like `search.idle.title`. Code uses the symbols Xcode generates
from the catalog (`Text(.searchIdleTitle)`), so a mistyped key doesn't compile.

### Notes

- Coordinates in `locations.json` are 3–7 km west of the city centers. They look copied from Google Maps URLs
  (`@lat,long,zoom` is the camera center, shifted by the side panel). The app shows the data as is.
- The feed is served with `Cache-Control: max-age=300`. To see the error screen, delete the app and launch it offline.
- Any app can open `wikipedia://` URLs, so the fork validates coordinates.

## Wikipedia changes

All changes: [compare with upstream](https://github.com/Dax220/wikipedia-ios/compare/main...places-deeplink)

- **Opens on the Places tab at launch**, as the assignment requires (`launchTab` in `WMFAppViewController`).
- **Deep link with coordinates:** `wikipedia://places?lat=52.3676&lon=4.9041` opens Places tab centered on the given location
  instead of the current one. Missing or invalid coordinates fall back to the regular Places tab.
  Covered by unit tests: [`NSUserActivityPlacesCoordinateTests`](https://github.com/Dax220/wikipedia-ios/blob/places-deeplink/WikipediaUnitTests/Code/NSUserActivityPlacesCoordinateTests.swift).
