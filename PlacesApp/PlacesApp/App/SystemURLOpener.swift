//
//  SystemURLOpener.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import UIKit

struct SystemURLOpener: URLOpening {
    
    func open(_ url: URL) async -> Bool {
        // open(_:) returns false if we're already switching to Wikipedia (e.g. tap on two items at once),
        // so it can't tell whether Wikipedia is installed. canOpenURL can.
        // Requires "wikipedia" in LSApplicationQueriesSchemes.
        if UIApplication.shared.canOpenURL(url) {
            await UIApplication.shared.open(url)
            return true
        }
        return false
    }
}
