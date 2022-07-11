//
//  SwipeLocationsView.swift
//  meetafriend
//
//  Created by Luca on 17.05.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SwipeLocationsView: View {
    @EnvironmentObject var locationService: LocationServiceImpl
    @EnvironmentObject var mapService: MapServiceImpl
    
    let location: Location?
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                // Background Image
                WebImage(url: URL(string: location?.locationPictureURL ?? ""))
                    .resizable()
                    .blur(radius: 2)
                    .background(Color("MAFgray"))
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(location?.name ?? "Name")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("MAFwhite"))
                        
                        
                        Text(location?.subDescription ?? "Sub Description")
                            .fontWeight(.bold)
                            .foregroundColor(Color("MAFwhite"))
                        
                        if location?.joinedUsers.count ?? 0 > 1 {
                            
                            Text("\(location?.joinedUsers.count ?? 1) people active")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("MAFwhite"))
                                .padding(.top)
                            
                        } else if location?.joinedUsers.count ?? 0 == 1 {
                            
                            Text("\(location?.joinedUsers.count ?? 10) person active")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("MAFwhite"))
                                .padding(.top)
                        
                        } else {
                            
                            Text("No one is here yet")
                                .font(.title3) 
                                .fontWeight(.bold)
                                .foregroundColor(Color("MAFwhite"))
                                .padding(.top)
                        
                        }
                        
                        HStack {
                            if (location?.joinedUsers.count ?? 6 > 5) {
                                Text("**popular!**")
                                    .foregroundColor(Color("MAFblack"))
                            }
                            
                            Image(systemName: "person.3.sequence.fill")
                                .frame(width: 7, height: 7)
                                .foregroundColor(Color("MAFyellow"))
                                .padding(.leading, 10)
                                .padding(.trailing, 8)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(Color("MAFwhite"))
                        .cornerRadius(30)
                    }
                    .padding(40)
                    
                    Spacer()
                    
                    VStack {
                        if (location?.privateParty ?? true) {
                            Text("**private event**")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .foregroundColor(Color("MAFblack"))
                                .background(Color("MAFwhite"))
                                .cornerRadius(30)
                                .padding(.top, 15)
                        }
                        
                        if (mapService.closeTo.contains(where: { $0 == (location?.id ?? "") })) {
                            Button {
                                locationService.joinLocation(lid: location?.id ?? "")
                            } label: {
                                ZStack {
                                    Text("enter")
                                        .fontWeight(.bold)
                                }
                                .padding([.leading, .trailing], 30)
                                .padding([.top, .bottom], 10)
                                .buttonStyle(.plain)
                                .background(Color("MAFwhite"))
                                .cornerRadius(25)
                                .shadow(radius: 10)
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink(destination: MapView()) {
                                ZStack {
                                    Text("show on map")
                                        .fontWeight(.bold)
                                }
                                .padding([.leading, .trailing], 30)
                                .padding([.top, .bottom], 10)
                                .buttonStyle(.plain)
                                .background(.white)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 35)
                }
            
            }
            .cornerRadius(30)
            .frame(maxWidth: .infinity)
            .overlay(location?.privateParty ?? true
                     ? RoundedRectangle(cornerRadius: 38)
                        .stroke(Color("MAFyellow"), lineWidth: 5)
                        .padding(-6)
                     : nil
            )
        }
        .frame(maxWidth: .infinity)
        .navigationBarHidden(true)
        .padding()
    }
}



struct SwipeLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeLocationsView(location: nil)
            .environmentObject(MapServiceImpl())
            .environmentObject(LocationServiceImpl())
    }
}
