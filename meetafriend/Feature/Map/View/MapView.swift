//
//  MapView.swift
//  meetafriend
//
//  Created by Luca on 17.05.22.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct MapView: View {
    @State var shownLocationName = ""
    @State var shownLocationSubDescription = ""
    @State var shownLocationPictureURL = ""
    
    @EnvironmentObject var locationService: LocationServiceImpl
    @EnvironmentObject var mapService: MapServiceImpl
    
    @State var isClicked = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: $mapService.mapViewModel.region, interactionModes: .all, showsUserLocation: true, annotationItems: locationService.locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)) {
                    
                    Button {
                        shownLocationName = location.name
                        shownLocationSubDescription = location.subDescription
                        shownLocationPictureURL = location.locationPictureURL
                        
                        isClicked = true
                    } label: {
                        MapLocationDot(locationProfileURL: location.locationPictureURL)
                    }
                }
                
            }
            .accentColor(Color("MAFyellow"))
            .edgesIgnoringSafeArea(.all)
            .popup(isPresented: $isClicked) {
                BottomPopupView {
                    MapLocationInfo(title: shownLocationName, subDescription: shownLocationSubDescription, locationProfileURL: shownLocationPictureURL)
                }
            }
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        if (isClicked) { isClicked = false }
                    }
            )
            
            /*NavigationLink(destination: HomeView()) {
                Image(systemName: "chevron.backward.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(radius: 8)
                    .padding()
            }
            .buttonStyle(.plain)
            */
            
        }
        .navigationBarBackButtonHidden(false)
        .frame(maxWidth: .infinity) //, maxHeight: .infinity)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(LocationServiceImpl())
            .environmentObject(MapServiceImpl())
    }
}
