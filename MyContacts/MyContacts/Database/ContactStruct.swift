//
//  ContactStruct.swift
//  MyContacts
//
//  Created by Osman Balci, Nickolas Chu on 4/23/24.
//  Copyright © 2024 Nick Chu. All rights reserved.
//

import Foundation

/*
  <> ContactStruct is used to populate the database with intitial content
     in DatabaseInitialContent.json for which it has to be Decodable.
*/
struct ContactStruct: Decodable {
    
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
    
}
