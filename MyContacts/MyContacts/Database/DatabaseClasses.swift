//
//  DatabaseClasses.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
final class Contact {
    
    var firstName: String
    var lastName: String
    var favorite: Bool
    var photoFullFilename: String
    var company: String
    var phone: String
    var email: String
    var url: String
    var notes: String
    var addressLine1: String
    var addressLine2: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    
    init(firstName: String, lastName: String, favorite: Bool, photoFullFilename: String, company: String, phone: String, email: String, url: String, notes: String, addressLine1: String, addressLine2: String, city: String, state: String, zipCode: String, country: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.favorite = favorite
        self.photoFullFilename = photoFullFilename
        self.company = company
        self.phone = phone
        self.email = email
        self.url = url
        self.notes = notes
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
    }
    
}
