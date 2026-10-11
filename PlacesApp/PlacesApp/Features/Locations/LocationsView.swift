//
//  LocationsView.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import SwiftUI

struct LocationsView: View {
    
    @Bindable var model: LocationsModel
    @Bindable var searchModel: SearchModel
    
    var body: some View {
        NavigationStack {
            SearchableContent(searchModel: searchModel) {
                content
            }
            .navigationTitle("Places")
            .searchable(text: $searchModel.query, prompt: "Place name or coordinates")
        }
        .task { await model.load() }
        .wikipediaMissingAlert(isPresented: $model.isWikipediaMissing)
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

private struct SearchableContent<Content: View>: View {
    
    @Environment(\.isSearching) private var isSearching
    let searchModel: SearchModel
    @ViewBuilder let content: Content
    
    var body: some View {
        if isSearching {
            SearchView(model: searchModel)
        } else {
            content
        }
    }
}
