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
    @EnvironmentObject var locationService: LocationServiceImpl
    
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: $mapViewModel.region, interactionModes: .all, showsUserLocation: true, annotationItems: locationService.locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)) {
                    Image(systemName: "map")
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color(.label))
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
            }
            .accentColor(Color(.yellow))
            .onAppear {
                mapViewModel.checkIfLocationServicesIsEnabled()
            }
            
            NavigationLink(destination: HomeView()) {
                Image(systemName: "chevron.backward.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(radius: 8)
                    .padding()
                    .offset(y: 45)
            }
            .buttonStyle(.plain)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(LocationServiceImpl())
    }
}


