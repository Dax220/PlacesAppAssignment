
# Places Assignment

Two apps:
- **PlacesApp** — SwiftUI app that lists locations and opens them in Wikipedia.
- **wikipedia-ios** — fork of the Wikipedia app (git submodule), modified to open a given location in Places.

## Getting started

    git clone --recurse-submodules https://github.com/Dax220/PlacesAppAssignment.git

## Wikipedia changes

All changes: [compare with upstream](https://github.com/Dax220/wikipedia-ios/compare/main...places-deeplink)
  
- **Running on a device:** follow the [original setup instructions](https://github.com/wikimedia/wikipedia-ios#building-and-running)
  (run `./scripts/setup` in `wikipedia-ios` and enter your team ID when asked),
  then change the team in the Debug configuration of the Wikipedia target to your own — it is currently set to mine.
- **Opens on the Places tab at launch**, as the assignment requires (`launchTab` in `WMFAppViewController`).
