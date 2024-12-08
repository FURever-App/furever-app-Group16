//
//  LandmarkAnnotation.swift
//  NearMeSwiftUI
//
//  Created by Yujie Li on 12/1/24.


// Make Sure LandmarkAnnotation include Landmark Complete Info
import MapKit
import UIKit


final class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let landmark: Landmark // Add Landmark ref

    init(landmark: Landmark) {
        self.title = landmark.name
        self.subtitle = landmark.address // add subtitle as address
        self.coordinate = landmark.coordinate
        self.landmark = landmark
    }
}

