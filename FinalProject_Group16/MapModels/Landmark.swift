//
//  Landmark.swift
//  NearMeSwiftUI
//
//  Created by Yujie Li on 12/1/24.

import Foundation
import MapKit

enum LandmarkType {
    case clinic
    case park
    case beach
    case unknown
    
    var tag: String {
        switch self {
        case .clinic: return "Hospital"
        case .park: return "Nature Park 🌳"
        case .beach: return "Relaxing Beach 🏖"
        case .unknown: return "Unknown Location ❓"
        }
    }
}

struct Landmark: Identifiable, Equatable {
    let id = UUID()
    let placemark: MKPlacemark
    let type: LandmarkType
    
    // 动态加载的属性
    var phone: String? // phone
    var hours: String? // operating hours
    var website: String? // website
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var address: String? {
        placemark.title // From`MKPlacemark` get dynamic location
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
    
    var tag: String {
        type.tag // Display tag based on type
    }
    
    var mapItem: MKMapItem {
        MKMapItem(placemark: placemark)
    }
}
