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
    
    @StateObject var mapViewModel = MapViewModel()
    @State var isClicked = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: $mapViewModel.region, interactionModes: .all, showsUserLocation: true, annotationItems: locationService.locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)) {
                    
                    Button {
                        isClicked.toggle()
                        if (isClicked) {
                            shownLocationName = location.name
                            shownLocationSubDescription = location.subDescription
                            shownLocationPictureURL = location.locationPictureURL
                        }
                    } label: {
                        MapLocationDot(locationProfileURL: location.locationPictureURL)
                    }
                }
                
            }
            .accentColor(Color(.yellow))
            .onAppear {
                mapViewModel.checkIfLocationServicesIsEnabled()
            }
            .edgesIgnoringSafeArea(.all)
            
            /*NavigationLink(destination: HomeView()) {
                Image(systemName: "chevron.backward.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(radius: 8)
                    .padding()
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .trailing))
            .offset(x: 5, y: 40)
            .edgesIgnoringSafeArea(.all)
            */
            
            
            if (isClicked) {
                ZStack(alignment: .bottom) {
                    MapLocationInfo(title: shownLocationName, subDescription: shownLocationSubDescription, locationProfileURL: shownLocationPictureURL)
                }
            }
            
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
