//
//  AddContact.swift
//  MyContacts
//
//  Created by Osman Balci on 4/9/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddContact: View {
    
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
                    HStack {
                        TextField("Enter first name", text: $firstName)
                            .autocapitalization(.words)
                        Button(action: {
                            firstName = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Last Name")) {
                    HStack {
                        TextField("Enter last name", text: $lastName)
                            .autocapitalization(.words)
                        Button(action: {
                            lastName = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Company Name")) {
                    HStack {
                        TextField("Enter company name", text: $company)
                            .autocapitalization(.words)
                        Button(action: {
                            company = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Phone Number")) {
                    HStack {
                        TextField("Enter phone number", text: $phone)
                            .autocapitalization(.none)
                        Button(action: {
                            phone = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Email Address")) {
                    HStack {
                        TextField("Enter email address", text: $email)
                            .autocapitalization(.none)
                        Button(action: {
                            email = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Website URL")) {
                    HStack {
                        TextField("Enter website URL", text: $url)
                            .autocapitalization(.none)
                        Button(action: {
                            url = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Notes"), footer:
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
            Group {
                Section(header: Text("Take or Pick Photo")) {
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
                }
                if pickedImage != nil {
                    Section(header: Text("Taken or Picked Photo")) {
                        pickedImage?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
                    }
                }
                Section(header: Text("Address Line 1")) {
                    HStack {
                        TextField("Enter address line 1", text: $addressLine1)
                            .autocapitalization(.words)
                        Button(action: {
                            addressLine1 = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Address Line 2")) {
                    HStack {
                        TextField("Enter address line 2", text: $addressLine2)
                            .autocapitalization(.words)
                        Button(action: {
                            addressLine2 = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("City Name")) {
                    HStack {
                        TextField("Enter city name", text: $city)
                            .autocapitalization(.words)
                        Button(action: {
                            city = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("State Abbreviation")) {
                    HStack {
                        TextField("Enter State abbreviation", text: $state)
                            .autocapitalization(.allCharacters)
                        Button(action: {
                            state = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Zip Code")) {
                    HStack {
                        TextField("Enter zip code", text: $zipCode)
                            .autocapitalization(.none)
                        Button(action: {
                            zipCode = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Country Name")) {
                    HStack {
                        TextField("Enter country name", text: $country)
                            .autocapitalization(.words)
                        Button(action: {
                            country = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
            }   // End of Group

        }   // End of Form
        .font(.system(size: 14))
        .navigationTitle("Add New Contact")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if inputDataValidated() {
                        saveNewContact()
                        
                        showAlertMessage = true
                        alertTitle = "Contact Added!"
                        alertMessage = "New contact is successfully added to the database!"
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Input Data!"
                        alertMessage = "All fields are required!"
                    }
                }) {
                    Text("Save")
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "Contact Added!" {
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
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {

        // Remove spaces, if any, at the beginning and at the end of the entered values
        let firstNameTrimmed    = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastNameTrimmed     = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let companyTrimmed      = company.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneTrimmed        = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailTrimmed        = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlTrimmed          = url.trimmingCharacters(in: .whitespacesAndNewlines)
        let notesTrimmed        = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressLine1Trimmed = addressLine1.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityTrimmed         = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let stateTrimmed        = state.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipCodeTrimmed      = zipCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let countryTrimmed      = country.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if firstNameTrimmed.isEmpty || lastNameTrimmed.isEmpty || companyTrimmed.isEmpty || phoneTrimmed.isEmpty ||
            emailTrimmed.isEmpty || urlTrimmed.isEmpty || notesTrimmed.isEmpty || addressLine1Trimmed.isEmpty ||
            cityTrimmed.isEmpty || stateTrimmed.isEmpty || zipCodeTrimmed.isEmpty || countryTrimmed.isEmpty {
            return false
        }
        
        // Photo must be taken or picked.
        if pickedImage == nil {
            return false
        }
        
        return true
    }
    
    /*
     ----------------------
     MARK: Save New Contact
     ----------------------
     */
    func saveNewContact() {
        
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
            fatalError("Picked or taken photo is not available!")
        }
        
        // ❎ Instantiate a new Contact object and dress it up
        let newContact = Contact(
            firstName: firstName,
            lastName: lastName,
            favorite: favorite,
            photoFullFilename: photoFullFilename,
            company: company,
            phone: phone,
            email: email,
            url: url,
            notes: notes,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country
        )
        
        // ❎ Insert the new Contact object into the database
        modelContext.insert(newContact)
        
        // Initialize @State variables
        showImagePicker = false
        pickedUIImage = nil
        
    }   // End of func saveNewContact()

}

#Preview {
    AddContact()
}
