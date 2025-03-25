//
//  ContactList.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

struct ContactList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Contact>(
        sortBy: [SortDescriptor(\Contact.lastName, order: .forward),])
    ) private var listOfAllContactsInDatabase: [Contact]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAllContactsInDatabase) { aContact in
                    NavigationLink(destination: ContactDetails(contact: aContact)) {
                        ContactItem(contact: aContact)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete the contact? It cannot be undone."),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                     'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                      element to be deleted. It is nil if the array is empty. Process it as an optional.
                                     */
                                     if let index = toBeDeleted?.first {
                                         let contactToDelete = listOfAllContactsInDatabase[index]
                                         modelContext.delete(contactToDelete)
                                     }
                                     toBeDeleted = nil
                                 }, secondaryButton: .cancel() {
                                     toBeDeleted = nil
                                 }
                             )
                        }   // End of alert
                    }   // End of NavigationLink
                }   // End of ForEach
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("Contacts")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                // Place the Add (+) button on right side of the toolbar
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddContact()) {
                        Image(systemName: "plus")
                    }
                }
            }   // End of toolbar
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     ---------------------------------
     MARK: Delete Selected Music Album
     ---------------------------------
     */
    private func delete(at offsets: IndexSet) {
        toBeDeleted = offsets
        showConfirmation = true
    }
}
