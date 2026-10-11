//
//  LocationsView.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import SwiftUI

struct LocationsView: View {
    
    @Bindable var model: LocationsModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Places")
        }
        .task { await model.load() }
        .alert("Wikipedia Isn't Installed", isPresented: $model.isWikipediaMissing) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Install the Wikipedia app to open this place on the map.")
        }
    }

    @ViewBuilder
    private var content: some View {
        
        switch model.state {
            
        case .loading:
            
            ProgressView("Loading places…")
            
        case .failed:
            
            ContentUnavailableView {
                Label("Couldn't Load Places", systemImage: "wifi.exclamationmark")
            } description: {
                Text("Check your connection and try again.")
            } actions: {
                Button("Try Again") {
                    Task { await model.load() }
                }
                .buttonStyle(.borderedProminent)
            }
            
        case .loaded(let locations) where locations.isEmpty:
            
            ContentUnavailableView(
                "No Places",
                systemImage: "mappin.slash",
                description: Text("There are no places to show.")
            )
            
        case .loaded(let locations):
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(locations.enumerated()), id: \.offset) { _, location in
                        PlaceCardView(content: PlaceCardContent(location: location)) {
                            Task { await model.select(location) }
                        }
                    }
                }
                .padding()
            }
        }
    }
}
