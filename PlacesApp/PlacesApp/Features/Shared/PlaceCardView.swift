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
                VStack(alignment: .leading, spacing: 6) {
                    Label(content.title, systemImage: "mappin.and.ellipse")
                    if let subtitle = content.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
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

#Preview("Search result with address") {
    PlaceCardView(
        content: PlaceCardContent(result: rijksmuseum),
        action: {}
    )
    .padding()
}

#Preview("Search result with address, accessibility size 2") {
    PlaceCardView(
        content: PlaceCardContent(result: rijksmuseum),
        action: {}
    )
    .padding()
    .dynamicTypeSize(.accessibility2)
}

#Preview("Search result with address, accessibility size 5") {
    PlaceCardView(
        content: PlaceCardContent(result: rijksmuseum),
        action: {}
    )
    .padding()
    .dynamicTypeSize(.accessibility5)
}

private let rijksmuseum = PlaceSearchResult(
    title: "Rijksmuseum",
    subtitle: "Museumstraat 1, 1071 XX Amsterdam, Netherlands",
    lat: 52.359827,
    lon: 4.8850165
)
