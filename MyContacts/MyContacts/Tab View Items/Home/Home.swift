//
//  Home.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

struct Home: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Contact>(sortBy: [SortDescriptor(\Contact.lastName, order: .forward)])) private var listOfAllContactsInDatabase: [Contact]
    
    @AppStorage("darkMode") private var darkMode = false
    
    @State private var index = 0
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ZStack {
                    // Center Welcome image horizontally across the screen
                    HStack {
                        Image("Welcome")
                    }
                }   // End of ZStack
                .padding(.bottom, 20)
                
                /*
                 ------------------------------------------------------------------------------
                 Show an image slider of the cover photos of all of the contacts in the database.
                 ------------------------------------------------------------------------------
                 */
                getImageFromDocumentDirectory(filename: listOfAllContactsInDatabase[index].photoFullFilename.components(separatedBy: ".")[0],
                                              fileExtension: listOfAllContactsInDatabase[index].photoFullFilename.components(separatedBy: ".")[1],
                                              defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    .padding()
                
                    // Subscribe to the timer publisher
                    .onReceive(timer) { _ in
                        index += 1
                        if index > listOfAllContactsInDatabase.count - 1 {
                            index = 0
                        }
                    }
                
                // Contact Photo Caption
                Text("\(listOfAllContactsInDatabase[index].firstName) \(listOfAllContactsInDatabase[index].lastName)")
                    .font(.headline)
                    // Allow lines to wrap around
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
            }   // End of VStack
        }   // End of ScrollView
        .onAppear() {
            startTimer()
        }
        .onDisappear() {
            stopTimer()
        }

    }   // End of body var
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
}
