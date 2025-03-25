//
//  Settings.swift
//  MyContacts
//
//  Created by Osman Balci on 1/11/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct Settings: View {
    
    // dark mode
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dark Mode Setting")) {
                    Toggle("Dark Mode", isOn: $darkMode)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
