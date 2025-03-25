//
//  DatabaseSearch.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

// Global variable to contain the search results
var databaseSearchResults = [Contact]()

public func conductDatabaseSearch() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer

    do {
        // Create a database container to manage Contact objects
        modelContainer = try ModelContainer(for: Contact.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where Contact objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the global variable to contain the database search results
    databaseSearchResults = [Contact]()
    
    //-------------------------------------------
    // 1️⃣ Define the Search Criterion (Predicate)
    //-------------------------------------------
    
    /*
     Use 'localizedStandardContains' to perform CASE INSENSITIVE Search
     
        "This is the most appropriate method for doing user-level string searches,
        similar to how searches are done generally in the system.
        The search is locale-aware, case and diacritic insensitive." [Apple]
     
     Use 'contains' to perform CASE SENSITIVE Search
     */
    
    var contactPredicate: Predicate<Contact>?
    
    switch searchCategory {
    case "All":
        contactPredicate = #Predicate<Contact> {
            $0.firstName.localizedStandardContains(searchQuery) ||
            $0.lastName.localizedStandardContains(searchQuery) ||
            $0.company.localizedStandardContains(searchQuery) ||
            $0.notes.localizedStandardContains(searchQuery) ||
            $0.city.localizedStandardContains(searchQuery) ||
            $0.state.localizedStandardContains(searchQuery) ||
            $0.country.localizedStandardContains(searchQuery)
        }
    case "First Name":
        contactPredicate = #Predicate<Contact> {
            $0.firstName.localizedStandardContains(searchQuery)
        }
    case "Last Name":
        contactPredicate = #Predicate<Contact> {
            $0.lastName.localizedStandardContains(searchQuery)
        }
    case "Company Name":
        contactPredicate = #Predicate<Contact> {
            $0.company.localizedStandardContains(searchQuery)
        }
    case "Notes":
        contactPredicate = #Predicate<Contact> {
            $0.notes.localizedStandardContains(searchQuery)
        }
    case "City Name":
        contactPredicate = #Predicate<Contact> {
            $0.city.localizedStandardContains(searchQuery)
        }
    case "State Abbreviation":
        contactPredicate = #Predicate<Contact> {
            $0.state.localizedStandardContains(searchQuery)
        }
    case "Country Name":
        contactPredicate = #Predicate<Contact> {
            $0.country.localizedStandardContains(searchQuery)
        }
    default:
        print("Search category is out of range!")
    }

    //-------------------------------
    // 2️⃣ Define the Fetch Descriptor
    //-------------------------------
    
    let fetchDescriptor = FetchDescriptor<Contact>(
        
        predicate: contactPredicate,
        
        /*
         .forward --> ascending order
         .reverse --> descending order
         Sort the search results w.r.t. Contact last name
         */
        sortBy: [SortDescriptor(\Contact.lastName, order: .forward)]
    )
    
    //-----------------------------
    // 3️⃣ Execute the Fetch Request
    //-----------------------------
    
    do {
        // Obtain all Contact objects satisfying the search criterion (Predicate)
        databaseSearchResults = try modelContext.fetch(fetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database")
    }

}
