//
//  MapView.swift
//  NearMeAppSwiftUI
//
//  Created by Yukie Li on 12/1/24.

import SwiftUI
import MapKit

extension Notification.Name {
    static let centerMap = Notification.Name("centerMap")
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion?
    let landmarks: [Landmark]
    var onAnnotationSelected: (Landmark) -> Void
    @ObservedObject var locationManager = LocationManager()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        
        if let region = region {
            mapView.setRegion(region, animated: true)
        }

        
        NotificationCenter.default.addObserver(forName: .centerMap, object: nil, queue: .main) { notification in
            if let region = notification.object as? MKCoordinateRegion {
                mapView.setRegion(region, animated: true)
            }
        }
        
        // Enable map interactions
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true


        return mapView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onAnnotationSelected: onAnnotationSelected)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.removeAnnotations(uiView.annotations)
        for landmark in landmarks {
            let annotation = LandmarkAnnotation(landmark: landmark)
            uiView.addAnnotation(annotation)
        }
        
        
        if let region = region {
           uiView.setRegion(region, animated: true)
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self, onAnnotationSelected: onAnnotationSelected)
        }


        if let location = locationManager.location {
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 10000,
                longitudinalMeters: 10000
            )
            uiView.setRegion(region, animated: true)
        }
    }
}


class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var onAnnotationSelected: (Landmark) -> Void

    init(_ parent: MapView, onAnnotationSelected: @escaping (Landmark) -> Void) {
        self.parent = parent
        self.onAnnotationSelected = onAnnotationSelected
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LandmarkAnnotation else { return nil }

        let identifier = "LandmarkAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true


            if let selectedLandmark = selectedLandmark {
                annotationView?.detailCalloutAccessoryView = createCalloutView(for: selectedLandmark)
            }

            // Add info button
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    // Handle annotation selection
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let annotation = view.annotation as? LandmarkAnnotation else { return }
//        onAnnotationSelected(annotation.landmark) // Pass selected landmark back
//    }
    
    private var selectedLandmark: Landmark?
    // Handle annotation selection
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? LandmarkAnnotation else { return }
        let landmark = annotation.landmark

        // 更新选中的 Landmark
        selectedLandmark = landmark
        onAnnotationSelected(annotation.landmark) // Pass selected landmark back
    }

    private func createCalloutView(for landmark: Landmark) -> UIView {
        let calloutView = UIStackView()
        calloutView.axis = .vertical
        calloutView.alignment = .leading
        calloutView.spacing = 8

        // 使用 Landmark 的 name 和 address
        let titleLabel = UILabel()
        titleLabel.text = landmark.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        calloutView.addArrangedSubview(titleLabel)

        if let address = landmark.address {
            let addressLabel = UILabel()
            addressLabel.text = address
            addressLabel.font = UIFont.systemFont(ofSize: 14)
            addressLabel.textColor = .gray
            calloutView.addArrangedSubview(addressLabel)
        }

        return calloutView
    }
}
