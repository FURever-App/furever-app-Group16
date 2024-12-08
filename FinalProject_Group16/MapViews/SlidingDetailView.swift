//
//  LandmarkDetailView.swift
//  NearMeAppSwiftUI
//
//  Created by Yukie Li on 12/5/24.



import SwiftUI
import MapKit

struct SlidingDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    
    let landmark: Landmark
    @State private var lookaroundScene: MKLookAroundScene?

    var body: some View {
        VStack {
            //
            HStack {
                VStack(alignment: .leading) {
                    Text(landmark.name)
                        .font(.title)
                        .bold()
                    Text(landmark.address ?? "No Address Available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
            }
            .padding()

            if let lookaroundScene {
                LookAroundPreview(initialScene: lookaroundScene)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
                    .padding()
            }

            Spacer()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding()
        .onAppear {
            loadLookAroundPreview()
        }
    }

    private func loadLookAroundPreview() {
        Task {
            let request = MKLookAroundSceneRequest(coordinate: landmark.coordinate)
            self.lookaroundScene = try? await request.scene
        }
    }
}
