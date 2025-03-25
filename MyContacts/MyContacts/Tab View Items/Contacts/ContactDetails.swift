//
//  ContactDetails.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI

struct ContactDetails: View {
    
    let contact: Contact
    
    @State private var showAlertMessage = false
    
    // contact information more fleshed out
    var body: some View {
        Form {
            Section(header: Text("Change This Contact's Attributes")) {
                NavigationLink(destination: ChangeContact(contact: contact)) {
                    Image(systemName: "pencil.circle")
                        .imageScale(.medium)
                        .font(Font.title.weight(.light))
                        .foregroundColor(.blue)
                }
            }
            Section(header: Text("Name")) {
                Text("\(contact.firstName) \(contact.lastName)")
            }
            Section(header: Text("Favorite")) {
                Image(systemName: contact.favorite ? "star.fill" : "star")
                    .imageScale(.medium)
                    .font(Font.title.weight(.light))
                    .foregroundColor(.blue)
            }
            Section(header: Text("Photo")) {
                getImageFromDocumentDirectory(filename: contact.photoFullFilename.components(separatedBy: ".")[0],
                                              fileExtension: contact.photoFullFilename.components(separatedBy: ".")[1],
                                              defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            Section(header: Text("Company Name")) {
                Text(contact.company)
            }
            // only display phone and email
            Section(header: Text("Phone Number")) {
                HStack {
                    Image(systemName: "phone.circle")
                        .imageScale(.medium)
                        .font(Font.title.weight(.light))
                        .foregroundColor(Color.blue)
                    
                    Text(contact.phone)
                }
            }
            Section(header: Text("Email Address")) {
                HStack {
                    Image(systemName: "envelope")
                        .imageScale(.medium)
                        .font(Font.title.weight(.light))
                        .foregroundColor(Color.blue)
                    
                    Text(contact.email)
                }
            }
            Section(header: Text("Website URL")) {
                // Tap the website URL to display the website externally in default web browser
                Link(destination: URL(string: contact.url)!) {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("Show Contact's Website")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                }
            }
            Section(header: Text("Notes")) {
                Text(contact.notes)
            }
            Section(header: Text("Postal Address")) {
                if !(contact.addressLine2).isEmpty && !(contact.state).isEmpty {
                    Text("\(contact.addressLine1)\n\(contact.addressLine2)\n\(contact.city), \(contact.state) \(contact.zipCode)\n\(contact.country)")
                }
                if (contact.addressLine2).isEmpty && !(contact.state).isEmpty {
                    Text("\(contact.addressLine1)\n\(contact.city), \(contact.state) \(contact.zipCode)\n\(contact.country)")
                }
                if !(contact.addressLine2).isEmpty && (contact.state).isEmpty {
                    Text("\(contact.addressLine1)\n\(contact.addressLine2)\n\(contact.city), \(contact.zipCode)\n\(contact.country)")
                }
                if (contact.addressLine2).isEmpty && (contact.state).isEmpty {
                    Text("\(contact.addressLine1)\n\(contact.city), \(contact.zipCode)\n\(contact.country)")
                }
            }
            

        }   // End of Form
        .font(.system(size: 14))
        .navigationTitle("Contact Details")
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {}
            }, message: {
              Text(alertMessage)
            })
        
    }   // End of body var

}
