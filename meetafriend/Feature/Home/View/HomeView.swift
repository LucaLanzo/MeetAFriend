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
    
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false
    @State var showAlert3: Bool = false
    @State var demoStarted: Bool = false
    
    
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
                    Button {
                        showAlert = true
                    } label: {
                        SettingsButtonView(buttonName: "DM's", imageName: "message")
                    }
                    .buttonStyle(.plain)
                    .alert("Feature coming soon!", isPresented: $showAlert) {
                                Button("Nice!", role: .cancel) { }
                        }
                    
                    
                    Spacer()
                    
                    
                    NavigationLink(destination: MapView()) {
                        SettingsButtonView(buttonName: "Map", imageName: "map")
                    }
                    .buttonStyle(.plain)
                    
                    
                    Spacer()
                    
                    /*
                    Button {
                       showAlert3 = true
                    } label: {SettingsButtonView(buttonName: "Demo", imageName: "questionmark")
                    }
                    .buttonStyle(.plain)
                    .alert("Karsten's demo mode: Alle locations joinbar. Have fun!", isPresented: $showAlert2) {
                     Pack das in den map service der soll checken ob demo ja nein
                            if (!demoStarted) {
                                Button("Start Demo Mode") {
                                    mapService.startDemoMode()
                                    demoStarted = true
                                }
                            } else {
                                Button("Stop Demo Mode") {
                                    mapService.stopDemoMode()
                                    demoStarted = false
                                }
                            }
                        }
                    
                    Spacer()
                   
                    
                    Button {
                        showAlert2 = true
                    } label: {
                        SettingsButtonView(buttonName: "Logout", imageName: "rectangle.portrait.and.arrow.right")
                    }
                    .buttonStyle(.plain)
                    .alert("Are you sure you want to log out?", isPresented: $showAlert2) {
                            Button("No", role: .cancel) { }
                            Button("Yes") {
                                sessionService.state = .loggedOut
                            }
                        }
                     */
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
        .onAppear {
            if (!locationService.listenStarted) {
                locationService.loadLocations()
            }
            if (!mapService.listenStarted) {
                mapService.getCoordinates()
            }
        }
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
                .environmentObject(LocationServiceImpl())
                .environmentObject(SessionServiceImpl())
                .environmentObject(MapServiceImpl())
        }
    }
}
