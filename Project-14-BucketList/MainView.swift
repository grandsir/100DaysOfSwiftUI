//
//  MainView.swift
//  BucketList
//
//  Created by Mehmet Atabey on 4.08.2021.
//

import SwiftUI
import MapKit

struct MainView: View {
    @Binding var centerCoordinate : CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace : MKPointAnnotation?
    @Binding var showingPlaceDetails : Bool
    @Binding var showingEditScreen : Bool


    var body: some View {
        ZStack {
            MapView(annotations: locations, centerCoordinate: $centerCoordinate , selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.title = "Example"
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                        
                        self.selectedPlace = newLocation
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
