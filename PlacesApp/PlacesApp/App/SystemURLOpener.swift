//
//  SystemURLOpener.swift
//  PlacesApp
//
//  Created by Maxim Tischenko on 11.10.2026.
//

import UIKit

struct SystemURLOpener: URLOpening {
    
    func open(_ url: URL) async -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            await UIApplication.shared.open(url)
            return true
        }
        return false
    }
}
