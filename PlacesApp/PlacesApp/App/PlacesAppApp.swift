//
//  PlacesAppApp.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import SwiftUI

@main
struct PlacesAppApp: App {
    
    @State private var dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            LocationsView(
                model: dependencies.locationsModel,
                searchModel: dependencies.searchModel
            )
        }
    }
}
