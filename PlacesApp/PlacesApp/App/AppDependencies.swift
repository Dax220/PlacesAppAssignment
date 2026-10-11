//
//  AppDependencies.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

final class AppDependencies {
    
    let locationsModel: LocationsModel
    let searchModel: SearchModel

    init() {
        let client: any HTTPClient = URLSession.shared
        let opener = SystemURLOpener()

        let locationsRepository = RemoteLocationsRepository(client: client, url: Constants.locationsURL)
        locationsModel = LocationsModel(repository: locationsRepository, opener: opener)

        searchModel = SearchModel(repository: MapKitPlaceSearchRepository(), opener: opener)
    }
}
