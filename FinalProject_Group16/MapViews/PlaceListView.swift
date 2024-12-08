//
//  PlaceListView.swift
//  NearMeAppSwiftUI
//
//  Created by Yujie Li on 12/1/24.
//
//

import SwiftUI

struct PlaceListView: View {
    let landmarks: [Landmark]
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(self.landmarks, id: \.id) { landmark in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(landmark.name)
                                .fontWeight(.bold)
                            Text(landmark.type == .clinic ? "Clinic" :
                                    landmark.type == .park ? "Park" :
                                    landmark.type == .beach ? "Beach" : "Unknown")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}
