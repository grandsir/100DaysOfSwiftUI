//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Mehmet Atabey on 3.08.2021.
//

import MapKit

extension MKPointAnnotation : ObservableObject {
    public var wrappedTitle: String {
        get  {
            self.title ?? "Unknown Title"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle : String {
        get {
            self.subtitle ?? "Unknown Subtitle"
        }
        set {
            self.subtitle = newValue
        }
    }
}
