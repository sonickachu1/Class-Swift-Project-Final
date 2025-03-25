//
//  ChangeContact.swift
//  MyContacts
//
//  Created by Osman Balci on 4/9/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct ChangeContact: View {
    
    // Input Parameter
    let contact: Contact
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    //-----------------------------------
    // Contact Database Object Properties
    //-----------------------------------
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var favorite = false
    @State private var photoFullFilename = ""
    @State private var company = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var url = ""
    @State private var notes = ""
    @State private var addressLine1 = ""
    @State private var addressLine2 = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = ""

    
    //--------------------------------
    // Contact Database Object Changes
    //--------------------------------
    @State private var changeFirstName = false
    @State private var changeLastName = false
    @State private var changeFavorite = false
    @State private var changeContactPhoto = false
    @State private var changeCompany = false
    @State private var changePhone = false
    @State private var changeEmail = false
    @State private var changeUrl = false
    @State private var changeNotes = false
    @State private var changeAddressLine1 = false
    @State private var changeAddressLine2 = false
    @State private var changeCity = false
    @State private var changeState = false
    @State private var changeZipCode = false
    @State private var changeCountry = false
    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    var body: some View {

        let camera = Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                if $0 == true {
                    usePhotoLibrary = false
                }
            }
        )
        let photoLibrary = Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                if $0 == true {
                    useCamera = false
                }
            }
        )
        
        Form {
            Group {
                Section(header: Text("First Name")) {
                    firstNameSubview
                }
                Section(header: Text("Last Name")) {
                    lastNameSubview
                }
                Section(header: Text("Favorite")) {
                    favoriteSubview
                }
                Section(header: Text("Company Name")) {
                    companySubview
                }
                Section(header: Text("Phone Number")) {
                    phoneSubview
                }
                Section(header: Text("Email Address")) {
                    emailSubview
                }
                Section(header: Text("Website URL")) {
                    urlSubview
                }
                Section(header: Text("Contact Notes")) {
                    notesSubview
                }
                if changeNotes {
                    Section(header: Text("New Contact Notes"), footer:
                        HStack {
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }) {
                                Image(systemName: "keyboard")
                                    .font(Font.title.weight(.light))
                                    .foregroundColor(.blue)
                            }
                       
                            Button(action: {    // Button to clear the text editor content
                                notes = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    ) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .font(.custom("Helvetica", size: 14))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                }
            }   // End of Group
            Group {
                Section(header: Text("Current Contact Photo")) {
                    VStack {
                        HStack {
                            getImageFromDocumentDirectory(filename: contact.photoFullFilename.components(separatedBy: ".")[0],
                                                          fileExtension: contact.photoFullFilename.components(separatedBy: ".")[1],
                                                          defaultFilename: "ImageUnavailable")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100.0, height: 100.0)
                            
                            if changeContactPhoto == false {
                                Button(action: {
                                    changeContactPhoto = true
                                }) {
                                    Image(systemName: "pencil.circle")
                                        .imageScale(.large)
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Button(action: {
                                    changeContactPhoto = false
                                    pickedImage = nil
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .imageScale(.small)
                                        .font(Font.title.weight(.light))
                                        .foregroundColor(.blue)
                                }
                            }
                        }   // End of HStack
                        
                        if changeContactPhoto {
                            VStack {
                                Toggle("Use Camera", isOn: camera)
                                Toggle("Use Photo Library", isOn: photoLibrary)
                                
                                Button("Get Photo") {
                                    showImagePicker = true
                                }
                                .tint(.blue)
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                            }
                        }   // End of If statement
                    }   // End of VStack
                }
                Section(header: Text("New Contact Photo")) {
                    contactPhotoImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                }

                Section(header: Text("Address Line 1")) {
                    addressLine1Subview
                }
                Section(header: Text("Address Line 2")) {
                    addressLine2Subview
                }
                Section(header: Text("City Name")) {
                    addressCitySubview
                }
                Section(header: Text("State Abbreviation")) {
                    addressStateSubview
                }
                Section(header: Text("Zip Code")) {
                    addressZipcodeSubview
                }
                Section(header: Text("Country Name")) {
                    addressCountrySubview
                }
            }   // End of Group
            
        }   // End of Form
        .font(.system(size: 14))
        .disableAutocorrection(true)
        .textInputAutocapitalization(.none)
        .navigationTitle("Change Contact Data")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    saveChanges()
                    
                    showAlertMessage = true
                    alertTitle = "Changes Saved!"
                    alertMessage = "Your changes have been successfully saved to the database."
                }) {
                    Text("Save")
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {
                  if alertTitle == "Changes Saved!" {
                      // Dismiss this view and go back to the previous view
                      dismiss()
                  }
              }
            }, message: {
              Text(alertMessage)
            })
        
        .onChange(of: pickedUIImage) {
            guard let uiImagePicked = pickedUIImage else { return }
            
            // Convert UIImage to SwiftUI Image
            pickedImage = Image(uiImage: uiImagePicked)
        }
        
        .sheet(isPresented: $showImagePicker) {
            /*
             For storage and performance efficiency reasons, we scale down the photo image selected from the
             photo library or taken by the camera to a smaller size with imageWidth and imageHeight in points.
             
             For high-resolution displays, 1 point = 3 pixels
             
             We use a square aspect ratio 1:1 for album cover photos with imageWidth = imageHeight = 200.0 points.
             
             You can select imageWidth and imageHeight values for other aspect ratios such as 4:3 or 16:9.
             
             imageWidth = 200.0 points and imageHeight = 200.0 points will produce an image with
             imageWidth = 600.0 pixels and imageHeight = 600.0 pixels which is about 84KB to 164KB in JPG format.
             */
            
            ImagePicker(uiImage: $pickedUIImage, sourceType: useCamera ? .camera : .photoLibrary, imageWidth: 200.0, imageHeight: 200.0)
        }
        
    }   // End of body var
    
    var firstNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.firstName)
                    if changeFirstName == false {
                        Button(action: {
                            changeFirstName = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            firstName = ""
                            changeFirstName = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeFirstName {
                    TextField("Change first name", text: $firstName)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var lastNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.lastName)
                    if changeLastName == false {
                        Button(action: {
                            changeLastName = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            lastName = ""
                            changeLastName = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeLastName {
                    TextField("Change last name", text: $lastName)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var favoriteSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Image(systemName: contact.favorite ? "star.fill" : "star")
                        .imageScale(.medium)
                        .font(Font.title.weight(.light))
                        .foregroundColor(.blue)

                    if changeFavorite == false {
                        Button(action: {
                            changeFavorite = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            changeFavorite = false
                            favorite = contact.favorite
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeFavorite {
                    Toggle("Set Favorite On or Off", isOn: $favorite)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var companySubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.company)
                    if changeCompany == false {
                        Button(action: {
                            changeCompany = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            company = ""
                            changeCompany = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeCompany {
                    TextField("Change company name", text: $company)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }

    var phoneSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.phone)
                    if changePhone == false {
                        Button(action: {
                            changePhone = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            phone = ""
                            changePhone = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changePhone {
                    TextField("Change phone number", text: $phone)
                        .autocapitalization(.none)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var emailSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.email)
                    if changeEmail == false {
                        Button(action: {
                            changeEmail = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            email = ""
                            changeEmail = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeEmail {
                    TextField("Change email address", text: $email)
                        .autocapitalization(.none)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var urlSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.url)
                    if changeUrl == false {
                        Button(action: {
                            changeUrl = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            url = ""
                            changeUrl = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeUrl {
                    TextField("Change website URL", text: $url)
                        .autocapitalization(.none)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var notesSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.notes)
                    if changeNotes == false {
                        Button(action: {
                            changeNotes = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            notes = ""
                            changeNotes = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
            }   // End of VStack
        )   // End of AnyView
    }
    
    var contactPhotoSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    getImageFromDocumentDirectory(filename: contact.photoFullFilename.components(separatedBy: ".")[0],
                                                  fileExtension: contact.photoFullFilename.components(separatedBy: ".")[1],
                                                  defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                    
                    if changeContactPhoto == false {
                        Button(action: {
                            changeContactPhoto = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            changeContactPhoto = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
            }   // End of VStack
        )   // End of AnyView
    }
    
    var contactPhotoImage: Image {
        
        if let photoImage = pickedImage {
            return photoImage
        } else {
            return Image("ImageUnavailable")
        }
    }
    
    var addressLine1Subview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.addressLine1)
                    if changeAddressLine1 == false {
                        Button(action: {
                            changeAddressLine1 = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            addressLine1 = ""
                            changeAddressLine1 = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeAddressLine1 {
                    TextField("Change address line 1", text: $addressLine1)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var addressLine2Subview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.addressLine2)
                    if changeAddressLine2 == false {
                        Button(action: {
                            changeAddressLine2 = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            addressLine2 = ""
                            changeAddressLine2 = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeAddressLine2 {
                    TextField("Change address line 2", text: $addressLine2)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var addressCitySubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.city)
                    if changeCity == false {
                        Button(action: {
                            changeCity = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            city = ""
                            changeCity = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeCity {
                    TextField("Change city name", text: $city)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var addressStateSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.state)
                    if changeState == false {
                        Button(action: {
                            changeState = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            state = ""
                            changeState = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeState {
                    TextField("Change State Abbreviation", text: $state)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var addressZipcodeSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.zipCode)
                    if changeZipCode == false {
                        Button(action: {
                            changeZipCode = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            zipCode = ""
                            changeZipCode = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeZipCode {
                    TextField("Change Zip Code", text: $zipCode)
                        .autocapitalization(.none)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    var addressCountrySubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(contact.country)
                    if changeCountry == false {
                        Button(action: {
                            changeCountry = true
                        }) {
                            Image(systemName: "pencil.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            country = ""
                            changeCountry = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.small)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                        }
                    }
                }   // End of HStack
                if changeCountry {
                    TextField("Change country name", text: $country)
                        .autocapitalization(.words)
                }
            }   // End of VStack
        )   // End of AnyView
    }
    
    /*
     ----------------------------
     MARK: - Save Contact Changes
     ----------------------------
     */
    func saveChanges() {

        if firstName != "" {
            contact.firstName = firstName
        }
        if lastName != "" {
            contact.lastName = lastName
        }
        if changeFavorite && favorite != contact.favorite {
            contact.favorite = favorite
        }
        if company != "" {
            contact.company = company
        }
        if phone != "" {
            contact.phone = phone
        }
        if email != "" {
            contact.email = email
        }
        if url != "" {
            contact.url = url
        }
        if notes != "" {
            contact.notes = notes
        }
        
        if (pickedImage != nil) {
            //--------------------------------------------------
            // Store Taken or Picked Photo to Document Directory
            //--------------------------------------------------
            let photoFullFilename = UUID().uuidString + ".jpg"
            
            if let photoData = pickedUIImage {
                if let jpegData = photoData.jpegData(compressionQuality: 1.0) {
                    let fileUrl = documentDirectory.appendingPathComponent(photoFullFilename)
                    try? jpegData.write(to: fileUrl)
                }
            } else {
                if let uiImage = UIImage(named: "ImageUnavailable") {
                    if let jpgData = uiImage.jpegData(compressionQuality: 0.8) {
                        let url = documentDirectory.appendingPathComponent(photoFullFilename)
                        try? jpgData.write(to: url)
                    }
                }
            }
            contact.photoFullFilename = photoFullFilename
        }
        
        if addressLine1 != "" {
            contact.addressLine1 = addressLine1
        }
        if addressLine2 != "" {
            contact.addressLine2 = addressLine2
        }
        if city != "" {
            contact.city = city
        }
        if state != "" {
            contact.state = state
        }
        if zipCode != "" {
            contact.zipCode = zipCode
        }
        if country != "" {
            contact.country = country
        }
        
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
        
    }   // End of function saveChanges
    
}


