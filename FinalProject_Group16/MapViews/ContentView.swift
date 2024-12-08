//
//  ContentView.swift
//  NearMeAppSwiftUI
//
//  Created by Yukie Li on 12/1/24.
//
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var landmarks: [Landmark] = []
    @State private var search: String = ""
    @State private var tapped: Bool = false
    @State private var selectedLandmark: Landmark? = nil // Current selected location
    @State private var lookaroundScene: MKLookAroundScene? = nil // 当前的 LookAround 场景
    @State private var isLoading: Bool = false // 是否正在加载场景
    @State private var lastLoadedLandmarkID: UUID? = nil // 上一次加载的 Landmark ID


    
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
    
    private func loadLookAroundScene(for landmark: Landmark) {
            // 如果已经加载了相同的地标，直接返回
            if lastLoadedLandmarkID == landmark.id {
                return
            }
            
            lastLoadedLandmarkID = landmark.id // 更新最近加载的地标
            isLoading = true // 开始加载
            lookaroundScene = nil // 清空旧场景

            let request = MKLookAroundSceneRequest(coordinate: landmark.coordinate)
            Task {
                do {
                    let scene = try await request.scene
                    DispatchQueue.main.async {
                        // 只有当前地标仍然匹配时，更新场景
                        if self.lastLoadedLandmarkID == landmark.id {
                            self.lookaroundScene = scene
                            self.isLoading = false
                        }
                    }
                } catch {
                    print("Failed to load LookAround scene: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        if self.lastLoadedLandmarkID == landmark.id {
                            self.lookaroundScene = nil // 清空 LookAroundScene
                            self.isLoading = false
                        }
                    }
                }
            }
        }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Main MapView with binding for region
            MapView(region: $currentRegion, landmarks: landmarks) { landmark in
                print("Selected landmark: \(landmark.name)")
                self.selectedLandmark = landmark
                self.isDetailVisible = true
                self.loadLookAroundScene(for: landmark) // 每次选择地标时加载 LookAroundScene
            }
            .edgesIgnoringSafeArea(.all)
            
            // LookAround 场景预览
            if isLoading {
                ProgressView("Loading LookAround...")
                    .frame(height: 300)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .padding()
            } else if let selectedLandmark {
                VStack {
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading) {
                            // 标题
                            Text(selectedLandmark.name)
                                .font(.title)
                                .bold()
                                .padding(.horizontal)
                                .padding(.top)

                            if let address = selectedLandmark.address {
                                Text(address)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            }

                            if let lookaroundScene {
                                LookAroundPreview(initialScene: lookaroundScene)
                                    .frame(height: 200)
                                    .cornerRadius(10)
                                    .padding()
                            } else {
                                // 当没有 LookAroundScene 时显示占位图标
                                VStack {
                                    Spacer()
                                    Image(systemName: "eye.slash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                    Text("No Look Around available")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(height: 200)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .padding()

                        // 关闭按钮
                        Button(action: {
                            self.lookaroundScene = nil
                            self.selectedLandmark = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                                .padding(10)
                        }
                        .offset(x: -10, y: -10)
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: lookaroundScene)
            }

//            // 显示 LookAroundView
//            if isLoading {
//                ProgressView("Loading LookAround...")
//                    .frame(height: 300)
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .shadow(radius: 10)
//                    .padding()
//            } else if let lookaroundScene, let selectedLandmark {
//                VStack {
//                    Spacer()
//                    LookAroundPreview(initialScene: lookaroundScene)
//                        .frame(height: 300)
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(radius: 10)
//                        .padding()
//                }
//                .transition(.move(edge: .bottom))
//                .animation(.easeInOut, value: lookaroundScene)
//            }

        
            
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

