//
//  LookAroundView.swift
//  NearMeAppSwiftUI
//
//  Created by Yukie Li on 12/5/24.
//
import SwiftUI
import MapKit

struct LookAroundView: View {
    let landmark: Landmark
    let onClose: () -> Void

    @State private var lookaroundScene: MKLookAroundScene?

    var body: some View {
        VStack {
            HStack {
                Text(landmark.name)
                    .font(.title)
                    .bold()
                Spacer()
                Button("Close") {
                    onClose()// Close the view
                }
            }
            .padding()

            // LookAround
            if let lookaroundScene {
                LookAroundPreview(initialScene: lookaroundScene)
                    .frame(height: 200)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
                    .padding()
            }
        }
        .onAppear {
            loadLookAroundScene()
        }
        .onChange(of: landmark) { _ in
            loadLookAroundScene()
        }
    }

    private func loadLookAroundScene() {
   
        let request = MKLookAroundSceneRequest(coordinate: landmark.coordinate)
        Task {
            do {
                let scene = try await request.scene
                DispatchQueue.main.async {
                    lookaroundScene = scene 
                }
            } catch {
                print("Failed to load LookAround scene: \(error)")
            }
        }
    }
}
