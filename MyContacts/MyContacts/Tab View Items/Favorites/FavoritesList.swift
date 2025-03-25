//
//  FavoritesList.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData
 
struct FavoritesList: View {
    //
    //  Obtain all of the contacts in the database
    //  whose ‘favorite’ attribute value = true (filter:)
    //  and sort the filtered results with respect to last name (sort:)
    //
    @Query(filter: #Predicate<Contact> { $0.favorite == true},
           sort: [SortDescriptor(\Contact.lastName, order: .forward)]) var listOfFavoriteContacts: [Contact]
   
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfFavoriteContacts) { aContact in
                    NavigationLink(destination: ContactDetails(contact: aContact)) {
                        ContactItem(contact: aContact)
                    }
                }
            }
            .font(.system(size: 14))
            .navigationTitle("Favorite Contacts")
            .toolbarTitleDisplayMode(.inline)
           
        }
    }
}
