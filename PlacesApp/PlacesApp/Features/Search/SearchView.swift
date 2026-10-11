//
//  SearchView.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 12.10.2026.
//

import SwiftUI

struct SearchView: View {
    
    @Bindable var model: SearchModel

    var body: some View {
        content
            .onChange(of: model.state) { _, state in
                announce(state)
            }
            .wikipediaMissingAlert(isPresented: $model.isWikipediaMissing)
    }

    @ViewBuilder
    private var content: some View {
        
        switch model.state {
            
        case .idle:
            
            ContentUnavailableView(
                "Find a Place",
                systemImage: "magnifyingglass",
                description: Text("Type a place name or paste coordinates, like 52.3676, 4.9041.")
            )
            
        case .searching:
            
            ProgressView("Searching…")
            
        case .failed:
            
            ContentUnavailableView {
                Label("Search Failed", systemImage: "wifi.exclamationmark")
            } description: {
                Text("Check your connection and try again.")
            } actions: {
                Button("Try Again") {
                    model.retry()
                }
                .buttonStyle(.borderedProminent)
            }
            
        case .noResults:
            
            ContentUnavailableView.search(text: model.query)
            
        case .results(let results):
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(results.enumerated()), id: \.offset) { _, result in
                        PlaceCardView(content: PlaceCardContent(result: result)) {
                            Task { await model.select(result) }
                        }
                    }
                }
                .padding()
            }
        }
    }

    private func announce(_ state: SearchModel.State) {
        switch state {
        case .results(let results):
            AccessibilityNotification.Announcement(String(localized: "\(results.count) results")).post()
        case .noResults:
            AccessibilityNotification.Announcement(String(localized: "No results")).post()
        case .idle, .searching, .failed:
            break
        }
    }
}
