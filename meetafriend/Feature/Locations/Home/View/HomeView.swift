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
                Text("First Name: \(sessionService.userDetails?.firstName ?? "N/A")")
                Text("Locations: \(locationService.locationDetails?)")
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
        }
    }
}
