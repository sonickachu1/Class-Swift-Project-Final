//
//  ContentView.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/22/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        // tab bar and their appearances
        TabView {
            // links to the appropriate view
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavoritesList()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            ContactList()
                .tabItem {
                    Label("Contacts", systemImage: "rectangle.stack.person.crop.fill")
                }
            SearchDatabase()
                .tabItem {
                    Label("Search Database", systemImage: "magnifyingglass")
                }
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }   // End of TabView
        .onAppear {
           // Display TabView with opaque background
           let tabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithOpaqueBackground()
           UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
