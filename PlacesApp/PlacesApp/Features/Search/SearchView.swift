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
                .searchIdleTitle,
                systemImage: "magnifyingglass",
                description: Text(.searchIdleMessage)
            )
            
        case .searching:
            
            ProgressView(.searchLoading)
            
        case .failed:
            
            ContentUnavailableView {
                Label(.searchErrorTitle, systemImage: "wifi.exclamationmark")
            } description: {
                Text(.commonErrorConnectionMessage)
            } actions: {
                Button(.commonActionTryAgain) {
                    model.retry()
                }
                .buttonStyle(.borderedProminent)
            }
            
        case .noResults:
            
            ContentUnavailableView.search(text: model.query)
            
        case .results(let results):
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(results, id: \.self) { result in
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
            AccessibilityNotification.Announcement(String(localized: .searchAnnouncementResults(results.count))).post()
        case .noResults:
            AccessibilityNotification.Announcement(String(localized: .searchAnnouncementNoResults)).post()
        case .idle, .searching, .failed:
            break
        }
    }
}
