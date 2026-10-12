//
//  View+WikipediaMissingAlert.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 12.10.2026.
//

import SwiftUI

extension View {
    func wikipediaMissingAlert(isPresented: Binding<Bool>) -> some View {
        alert(.wikipediaMissingTitle, isPresented: isPresented) {
            Button(.commonActionOk, role: .cancel) {}
        } message: {
            Text(.wikipediaMissingMessage)
        }
    }
}
