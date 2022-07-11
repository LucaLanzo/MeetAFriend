//
//  MapLocationDotEnter.swift
//  meetafriend
//
//  Created by Luca on 11.07.22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore

struct MapLocationDotEnter: View {
    @EnvironmentObject var locationService: LocationServiceImpl
    
    let location: Location
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: location.locationPictureURL))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipped()
                .background(Color("MAFgray"))
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50)
                    .stroke(Color("MAFgray"), lineWidth: 2)
                    .padding(-3)
                )
                .zIndex(1)
            
            VStack(spacing: 0) {
                Text(location.name)
                    .foregroundColor(Color("MAFwhite"))
                    .padding(.trailing, 13)
                    .padding(.leading)
                    .padding(.vertical, 2)
                    .background(Color("MAFgray"))
                    .cornerRadius(9)
                
                Button {
                    locationService.joinLocation(lid: location.id!)
                } label: {
                    Text("Enter")
                        .foregroundColor(Color("MAFgray"))
                        .padding(.trailing, 13)
                        .padding(.leading)
                        .padding(.vertical, 2)
                        .background(Color("MAFwhite"))
                        .cornerRadius(9, corners: [.bottomLeft, .bottomRight])
                }
                .buttonStyle(.plain)
            }
            .offset(x: 90)
        }
    }
}

struct MapLocationDotEnter_Previews: PreviewProvider {
    static var previews: some View {
        MapLocationDotEnter(location: Location(id: "123", name: "Tscharlie's", subDescription: "Bar", country: "Germany", city: "Würzburg", zipCode: 97070, street: "Sanderstraße", houseNumber: 15, privateParty: false, coordinates: GeoPoint(latitude: 50.0, longitude: 50.0), joinedUsers: [], locationPictureURL: "invalid"))
            .environmentObject(LocationServiceImpl())
    }
}
