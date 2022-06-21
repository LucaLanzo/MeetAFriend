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
    @EnvironmentObject var mapService: MapServiceImpl
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                
                Text("Ready to meet new")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Friends?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
                
                HStack {
                    //NavigationLink() {
                        SettingsButtonView(buttonName: "DM's", imageName: "message")
                    //}
                    //.buttonStyle(.plain)
                    
                    Spacer()
                    
                    NavigationLink(destination: MapView()) {
                        SettingsButtonView(buttonName: "Map", imageName: "map")
                    }
                    .buttonStyle(.plain)
                    
                    
                    Spacer()
                    
                    //NavigationLink() {
                        SettingsButtonView(buttonName: "How to", imageName: "questionmark")
                   // }
                    //.buttonStyle(.plain)
                    
                    Spacer()
                    
                    //NavigationLink() {
                        SettingsButtonView(buttonName: "Setup", imageName: "gear")
                    //}
                    //.buttonStyle(.plain)
                }
            }
            .padding([.top, .bottom], 16)
            .padding([.leading, .trailing], 25)
            .frame(maxWidth: .infinity)
            .background(.yellow)
            .cornerRadius(15)
            
            
            
            Spacer()
            
            
            
            VStack(alignment: .leading, spacing: 16) {
                TabView {
                    ForEach(locationService.locations) { location in
                        SwipeLocationsView(location: location)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .cornerRadius(15)
                .padding()
                
            }
        }
        .navigationBarHidden(true)
        .padding([.leading, .trailing, .bottom], 10)
    }
}

struct SettingsButtonView: View {
    let buttonName: String
    let imageName: String
    
    var body: some View {
        VStack {
            Text(buttonName)
            
            Image(systemName: imageName)
                .font(.system(size: 20, weight: .bold))
                .frame(width: 48, height: 48)
                .foregroundColor(Color(.label))
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationServiceImpl())
                .environmentObject(MapServiceImpl())
        }
    }
}
