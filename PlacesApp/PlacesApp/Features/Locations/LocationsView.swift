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
            .navigationTitle(.placesTitle)
            .searchable(text: $searchModel.query, prompt: Text(.searchPrompt))
        }
        .task { await model.load() }
        .wikipediaMissingAlert(isPresented: $model.isWikipediaMissing)
    }

    @ViewBuilder
    private var content: some View {
        
        switch model.state {
            
        case .loading:
            
            ProgressView(.placesLoading)
            
        case .failed:
            
            ContentUnavailableView {
                Label(.placesErrorTitle, systemImage: "wifi.exclamationmark")
            } description: {
                Text(.commonErrorConnectionMessage)
            } actions: {
                Button(.commonActionTryAgain) {
                    Task { await model.load() }
                }
                .buttonStyle(.borderedProminent)
            }
            
        case .loaded(let locations) where locations.isEmpty:
            
            ContentUnavailableView(
                .placesEmptyTitle,
                systemImage: "mappin.slash",
                description: Text(.placesEmptyMessage)
            )
            
        case .loaded(let locations):
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(locations, id: \.self) { location in
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
