//
//  View+WikipediaMissingAlert.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 12.10.2026.
//

import SwiftUI

extension View {
    func wikipediaMissingAlert(isPresented: Binding<Bool>) -> some View {
        alert("Wikipedia Isn't Installed", isPresented: isPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Install the Wikipedia app to open this place on the map.")
        }
    }
}
