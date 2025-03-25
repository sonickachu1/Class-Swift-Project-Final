/*
**********************************************************
*   Statement of Compliance with the Stated Honor Code   *
**********************************************************
I hereby declare on my honor and I affirm that
 
 (1) I have not given or received any unauthorized help on this exam, and
 (2) All work is my own in this exam.
 
I am hereby writing my name as my signature to declare that the above statements are true:
   
      Nickolas Rodolfo Cabrera Chu
 
**********************************************************
 */
//
//  MyContactsApp.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/22/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct MyContactsApp: App {
    
    init() {
        // Create Contacts Database upon app Launch IF the app is being launched for the first time.
        createContactsDatabase()      // Given in DatabaseCreation.swift
    }
    
    @Environment(\.undoManager) var undoManager
    
    @AppStorage("darkMode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)
            
                /*
                 Inject the Model Container into the environment so that you can access its Model Context
                 in a SwiftUI file by using @Environment(\.modelContext) private var modelContext
                 */
                .modelContainer(for: [Contact.self], isUndoEnabled: true)
        }
    }
}
