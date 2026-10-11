//
//  PlaceCardView.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import SwiftUI

struct PlaceCardView: View {
    let content: PlaceCardContent
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            GroupBox {
                LabeledContent("Latitude", value: content.latitude)
                LabeledContent("Longitude", value: content.longitude)
            } label: {
                Label(content.title, systemImage: "mappin.and.ellipse")
            }
            .labeledContentStyle(.adaptive)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(content.accessibilityLabel)
        .accessibilityValue(content.accessibilityValue)
        .accessibilityHint("Opens in Wikipedia")
    }
}

#Preview("Named") {
    PlaceCardView(
        content: PlaceCardContent(location: Location(name: "Amsterdam", lat: 52.3547498, lon: 4.8339215)),
        action: {}
    )
    .padding()
}

#Preview("Unnamed, accessibility size 2") {
    PlaceCardView(
        content: PlaceCardContent(location: Location(name: nil, lat: 40.4380638, lon: -3.7495758)),
        action: {}
    )
    .padding()
    .dynamicTypeSize(.accessibility2)
}

#Preview("Unnamed, accessibility size 5") {
    PlaceCardView(
        content: PlaceCardContent(location: Location(name: nil, lat: 40.4380638, lon: -3.7495758)),
        action: {}
    )
    .padding()
    .dynamicTypeSize(.accessibility5)
}
