//
//  AddFriendView.swift
//  Milestone-projects-13-15
//
//  Created by Mehmet Atabey on 1.08.2021.
//

import SwiftUI

struct AddFriendView: View {
    @State private var uiImage : UIImage?
    @State private var showingImagePicker = false
    @State private var image : Image?
    @State private var name = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @Binding var persons : [Person]
    
    let locationFetcher = LocationFetcher()
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Group {
                if (image != nil) {
                    Form {
                        Section {
                            ZStack(alignment: .bottomLeading) {
                                image?
                                    .resizable()
                                    .scaledToFit()
                                Button(action: {
                                    self.showingImagePicker = true
                                }) {
                                    Text("Change Image")
                                        .fontWeight(.thin)
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.5))
                                }
                            }
                            
                        }
                        Section {
                            TextField("Name:", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            }
                        }
                    }
                else {
                    Button("Add new Image") {
                        self.locationFetcher.start()
                        self.showingImagePicker = true
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Add New Friend")
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                guard image != nil else {
                    error(title: "Image can not be Empty.", message: "Please select an Image")
                    return
                }
                
                guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    error(title: "Name can not be empty.", message: "Please enter a name.")
                    return
                }
                
                saveData()
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $uiImage)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func loadImage() {
        guard let uiImg = uiImage else { return }
        image = Image(uiImage: uiImg)
    }
    
    func saveData() {
        var latitude : Double? = nil
        var longtiude : Double? = nil
        
        if let location = self.locationFetcher.lastKnownLocation {
            latitude = location.latitude
            longtiude = location.longitude
        }
        
        let documentsDirectory = FileManager.default.getDocumentsDirectory
        let url = FileManager.default.fileNameInDocumentsDirectory("users.json")
        let person = Person(id: UUID(), name: name, longtiude: longtiude, latitude: latitude)
        
        do {
            persons.append(person)
            let encoder = try JSONEncoder().encode(persons)
            try encoder.write(to: url, options: [.atomic, .completeFileProtection])
            if let jpegData = uiImage?.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: documentsDirectory.appendingPathComponent(person.id.uuidString  + ".jpg"), options: [.atomic, .completeFileProtection])
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func error(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showingAlert = true
    }
}
