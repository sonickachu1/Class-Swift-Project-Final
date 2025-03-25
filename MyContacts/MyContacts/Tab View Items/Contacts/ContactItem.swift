//
//  ContactItem.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI

struct ContactItem: View {
    
    let contact: Contact
    
    // show summary of contact details
    var body: some View {
        HStack {
            getImageFromDocumentDirectory(filename: contact.photoFullFilename.components(separatedBy: ".")[0],
                                          fileExtension: contact.photoFullFilename.components(separatedBy: ".")[1],
                                          defaultFilename: "ImageUnavailable")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .shadow(radius: 5)  // as in Composition
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
                Text("\(contact.firstName) \(contact.lastName)")
                
                HStack {
                    Image(systemName: "phone.circle")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("\(contact.phone)")
                }
                
                HStack {
                    Image(systemName: "envelope")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text("\(contact.email)")
                }
                
            }
            .font(.system(size: 14))
        }
    }
}
