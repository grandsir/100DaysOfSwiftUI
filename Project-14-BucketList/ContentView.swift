//
//  ContentView.swift
//  BucketList
//
//  Created by Mehmet Atabey on 2.08.2021.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace : MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var isUnlocked = false

    
    var body: some View {
        if isUnlocked {
           MainView(centerCoordinate: $centerCoordinate, locations: $locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, showingEditScreen: $showingEditScreen)
            .alert(isPresented: $showingPlaceDetails, content: {
                Alert(title: Text(selectedPlace!.wrappedTitle), message: Text(selectedPlace!.wrappedSubtitle), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                    self.showingEditScreen = true
                })
            })
            .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
                if self.selectedPlace != nil {
                    EditView(placeMark: self.selectedPlace!)
                }
            }
            .onAppear(perform: loadData)
        }
        else {
            Button("Unlock places") {
                self.authenticate()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    
    }
    
    func loadData() {
        let fileName = FileManager.default.fileNameInDocumentsDirectory("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: fileName)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        }
        catch {
            print("Unable to load data")
        }
    }
    
    func saveData() {
        do {
            let fileName = FileManager.default.fileNameInDocumentsDirectory("SavedPlaces")
            
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: fileName, options: [.atomic, .completeFileProtection])
        }
        catch {
            print("Unable to save data")
        }
    }
    
    func authenticate() {
        var error : NSError?
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    }
                    else {
                        
                    }
                }
            }
        }
        else {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
