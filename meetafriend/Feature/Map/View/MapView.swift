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
    @EnvironmentObject var mapService: MapServiceImpl
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: $mapService.mapViewModel.region, interactionModes: .all, showsUserLocation: true, annotationItems: locationService.locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)) {
                    
                    if (!mapService.closeTo.contains(location.id!)) {
                        MapLocationDot(location: location)
                    } else {
                        MapLocationDotEnter(location: location)
                    }
                }
                    
            }
            .accentColor(Color("MAFyellow"))
            .edgesIgnoringSafeArea(.all)
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
