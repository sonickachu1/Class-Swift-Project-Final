//
//  DatabaseCreation.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

public func createContactsDatabase() {
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
    
    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |
     --------------------------------------------------------------------
     */
    let contactFetchDescriptor = FetchDescriptor<Contact>()
    
    var listOfAllContactsInDatabase = [Contact]()
    
    do {
        // Obtain all of the Contact objects from the database
        listOfAllContactsInDatabase = try modelContext.fetch(contactFetchDescriptor)
    } catch {
        fatalError("Unable to fetch MusicAlbum objects from the database")
    }
    
    if !listOfAllContactsInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    /*
     ----------------------------------------------------------
     | *** The app is being launched for the first time ***   |
     |   Database needs to be created and populated with      |
     |   the initial content in DatabaseInitialContent.json   |
     ----------------------------------------------------------
     */
    
    // Local variable contactStructList obtained from the JSON file to populate the database
    var contactStructList = [ContactStruct]()
    
    // The function is given in UtilityFunctions.swift
    contactStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "DatabaseInitialContent.json", fileLocation: "Main Bundle")
    
    for aContact in contactStructList {
        
        // Example photoFullFilename = "BradleyCooper.jpg"
        let filenameComponents = aContact.photoFullFilename.components(separatedBy: ".")
        
        // filenameComponents[0] = "BradleyCooper"
        // filenameComponents[1] = "jpg"
        
        // Copy the photo file from Assets.xcassets to document directory.
        // The function is given in UtilityFunctions.swift
        copyImageFileFromAssetsToDocumentDirectory(filename: filenameComponents[0], fileExtension: filenameComponents[1])
        
        // ❎ Instantiate a new Contact object and dress it up
        let newContact = Contact(firstName: aContact.firstName,
                                 lastName: aContact.lastName,
                                 favorite: aContact.favorite,
                                 photoFullFilename: aContact.photoFullFilename,
                                 company: aContact.company,
                                 phone: aContact.phone,
                                 email: aContact.email,
                                 url: aContact.url,
                                 notes: aContact.notes,
                                 addressLine1: aContact.addressLine1,
                                 addressLine2: aContact.addressLine2,
                                 city: aContact.city,
                                 state: aContact.state,
                                 zipCode: aContact.zipCode,
                                 country: aContact.country)
        
        // ❎ Insert the new Contact object into the database
        modelContext.insert(newContact)
        
    }   // End of the for loop
    
    /*
     =================================
     |   Save All Database Changes   |
     =================================
     🔴 NOTE: Database changes are automatically saved and SwiftUI Views are
     automatically refreshed upon State change in the UI or after a certain time period.
     But sometimes, you can manually save the database changes just to be sure.
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    
    print("Database is successfully created!")
    
}
