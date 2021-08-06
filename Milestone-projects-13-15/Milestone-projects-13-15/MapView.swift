//
//  MapView.swift
//  Milestone-projects-13-15
//
//  Created by Mehmet Atabey on 5.08.2021.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    let latiude : Double
    let longiude : Double
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
    
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: latiude, longitude: longiude)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
