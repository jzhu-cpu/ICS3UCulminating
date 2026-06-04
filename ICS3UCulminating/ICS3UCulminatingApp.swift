//
//  ICS3UCulminatingApp.swift
//  ICS3UCulminating
//
//  Created by Judy Z on 2026/6/1.
//

import SwiftUI

@main
struct ICS3UCulminatingApp: App {
    
    // Create the global settings object here
    @State private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(settings) // Share the settings with all views
        }
    }
}
