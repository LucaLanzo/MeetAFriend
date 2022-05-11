//
//  HomeView.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        // Text("First Name: \(sessionService.userDetails?.firstName ?? "N/A")")
        // ButtonView(title: "Logout") {
        //      sessionService.logout()
        // }
        
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Last Name: \(sessionService.userDetails?.lastName ?? "N/A")")
                Text("Age: \(sessionService.userDetails?.age ?? 18)")
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
