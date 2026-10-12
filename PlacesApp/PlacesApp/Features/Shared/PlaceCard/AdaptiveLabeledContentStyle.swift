//
//  AdaptiveLabeledContentStyle.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import SwiftUI

/// Puts the value next to the label. At text sizes above accessibility2
/// puts it below the label, because in one row words and numbers dont fit.
struct AdaptiveLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        AdaptiveLabeledContent(configuration: configuration)
    }
}

extension LabeledContentStyle where Self == AdaptiveLabeledContentStyle {
    static var adaptive: AdaptiveLabeledContentStyle { .init() }
}

private struct AdaptiveLabeledContent: View {
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    let configuration: LabeledContentStyleConfiguration
    
    var body: some View {
        if dynamicTypeSize > .accessibility2 {
            VStack(alignment: .leading, spacing: 2) {
                configuration.label
                configuration.content
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            HStack(alignment: .firstTextBaseline) {
                configuration.label
                Spacer()
                configuration.content
                    .foregroundStyle(.secondary)
            }
        }
    }
}
