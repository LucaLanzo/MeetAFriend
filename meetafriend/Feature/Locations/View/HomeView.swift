//
//  HomeView.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var locationService: LocationServiceImpl
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("First Name: \(sessionService.userDetails?.firstName ?? "loading...")")
                Text("Num Locations: \(locationService.locations.count)")
                Divider()
                
                ForEach(locationService.locations) { location in
                    Text("Location Name: \(location.name)")
                    Text("Joined Users: \(location.joinedUsers.formatted())")
                   
                    ButtonView(title: "Join Location") {
                        locationService.joinLocation(lid: location.id!)
                    }
                    
                    Divider()
                }
                
                ButtonView(title: "Logout") {
                    sessionService.logout()
                }
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Meet a friend")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationServiceImpl())
        }
    }
}
