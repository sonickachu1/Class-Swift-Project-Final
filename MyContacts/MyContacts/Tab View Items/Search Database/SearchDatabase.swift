//
//  SearchDatabase.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

// Global Variables
var searchCategory = ""
var searchQuery = ""

struct SearchDatabase: View {
    
    let searchCategoriesList = ["All", "First Name", "Last Name", "Company Name", "Notes", "City Name", "State Abbreviation", "Country Name"]
    @State private var selectedSearchCategoryIndex = 3  // default: Company Name
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    
    @State private var showAlertMessage = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image("SearchDatabase")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                        Spacer()
                    }
                }
                Section(header: Text("Select a Search Category")) {
                   
                    Picker("", selection: $selectedSearchCategoryIndex) {
                        ForEach(0 ..< searchCategoriesList.count, id: \.self) {
                            Text(searchCategoriesList[$0])
                        }
                    }
                }
                Section(header: Text("Search Query under Selected Category")) {
                    HStack {
                        TextField("Enter Search Query", text: $searchFieldValue)
                            .textFieldStyle(.roundedBorder)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                       
                        // Button to clear the text field
                        Button(action: {
                            searchFieldValue = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchDB()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a database search query!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)

                        Spacer()
                    }   // End of HStack
                }
                if searchCompleted {
                    Section(header: Text("List Contacts Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Contacts Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    Section(header: Text("Clear")) {
                        HStack {
                            Spacer()
                            Button("Clear") {
                                searchCompleted = false
                                searchFieldValue = ""
                                selectedSearchCategoryIndex = 3
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            
                            Spacer()
                        }
                    }
                }
            
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                  Button("OK") {}
                }, message: {
                  Text(alertMessage)
                })
            
        }   // End of NavigationStack
        
    }   // End of body var
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchDB() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // searchCategory and searchQuery are global search parameters defined on top of this file

        searchCategory = searchCategoriesList[selectedSearchCategoryIndex]
        searchQuery = queryTrimmed

        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if databaseSearchResults.isEmpty {
            return AnyView(NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!"))
        }
        
        return AnyView(SearchResultsList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {

        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (queryTrimmed.isEmpty) {
            return false
        }
        
        return true
    }
}
