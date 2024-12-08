//
//  ContentView.swift
//  NearMeAppSwiftUI
//
//  Created by Yukie Li on 12/1/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var landmarks: [Landmark] = []
    @State private var search: String = ""
    @State private var tapped: Bool = false
    @State private var selectedLandmark: Landmark? = nil // Current selected location
    
    @State private var isDetailVisible: Bool = false // Controls the visibility of the sliding detail view
    @State private var currentRegion: MKCoordinateRegion? = nil // save current region



    
    private func getNearByLandmarks() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                let mapItems = response.mapItems
                self.landmarks = mapItems.map { mapItem in
                    let placemark = mapItem.placemark
                    return Landmark(
                        placemark: placemark,
                        type: determineType(from: mapItem),
                        phone: mapItem.phoneNumber,
                        website: mapItem.url?.absoluteString
                    )
                }
            }
        }
    }
    
    

    // Dif LandmarkType
    private func determineType(from mapItem: MKMapItem) -> LandmarkType {
        if mapItem.name?.localizedCaseInsensitiveContains("Clinic") == true {
            return .clinic
        } else if mapItem.name?.localizedCaseInsensitiveContains("Park") == true {
            return .park
        } else if mapItem.name?.localizedCaseInsensitiveContains("Beach") == true {
            return .beach
        } else {
            return .unknown
        }
    }

    
    func calculateOffset() -> CGFloat {
        if self.landmarks.count > 0 && !self.tapped {
            return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4
        } else if self.tapped {
            return 100
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Main MapView with binding for region
            MapView(region: $currentRegion, landmarks: landmarks) { landmark in
                print("Selected landmark: \(landmark.name)")
                self.selectedLandmark = landmark
                self.isDetailVisible = true
            }
            .edgesIgnoringSafeArea(.all)
            
            // 显示 LookAroundView
            if let selectedLandmark {
                VStack {
                    Spacer()
                    LookAroundView(
                        landmark: selectedLandmark,
                        onClose: {
                            self.selectedLandmark = nil
                        }
                    )
                    .frame(height: 300)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .padding()
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: selectedLandmark)
            }
        
            
            Button(action: {
                
                if let location = locationManager.location {
                    let newRegion = MKCoordinateRegion(
                        center: location.coordinate,
                        latitudinalMeters: 10000,
                        longitudinalMeters: 10000
                    )
             
                    currentRegion = newRegion
                    
                }
            }) {
                Image(systemName: "location.circle.fill")
                    .font(.largeTitle)
                    .padding()
                    .clipShape(Circle())
                    .shadow(radius: 1)
            }
            .padding(.trailing, 16)
            
            Spacer()
            
            // 搜索框
            TextField("Search", text: $search, onCommit: {
                getNearByLandmarks()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .offset(y: 44)
            .padding()
            

        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
