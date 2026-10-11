//
//  AppDependencies.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import Foundation

final class AppDependencies {
    
    let locationsModel: LocationsModel

    init() {
        let client: any HTTPClient = URLSession.shared
        let locationsRepository = RemoteLocationsRepository(client: client, url: Constants.locationsURL)
        locationsModel = LocationsModel(repository: locationsRepository, opener: SystemURLOpener())
    }
}
