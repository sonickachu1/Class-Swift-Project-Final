//
//  SearchResultsList.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI

struct SearchResultsList: View {
    
    var body: some View {
        List {
            ForEach(databaseSearchResults) { aFoundContact in
                NavigationLink(destination: ContactDetails(contact: aFoundContact)) {
                    ContactItem(contact: aFoundContact)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)
        
    }   // End of body
}
