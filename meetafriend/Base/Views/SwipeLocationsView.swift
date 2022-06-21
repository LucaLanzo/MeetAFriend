//
//  SwipeLocationsView.swift
//  meetafriend
//
//  Created by Luca on 17.05.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SwipeLocationsView: View {
    @EnvironmentObject var mapService: MapServiceImpl
    @EnvironmentObject var locationService: LocationServiceImpl
    @State var locationClose: Bool = false

    let title: String
    let subDescription: String
    let locationProfileURL: String
    let locationID: String
    
    func getCloseTo() {
        self.locationClose = mapService.locations.first(where: { $0.id == locationID })!.closeTo
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                // Background Image
                WebImage(url: URL(string: locationProfileURL))
                    .resizable()
                    .blur(radius: 2)
                    .background(.gray)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(subDescription)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                    }
                    .padding(40)
                    
                    Spacer()
                    
                    VStack {
                        if (!locationClose) {
                            Button {
                                locationService.joinLocation(lid: locationID)
                            } label: {
                                ZStack {
                                    Text("Enter")
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
        }
        .frame(maxWidth: .infinity)
        .navigationBarHidden(true)
        .padding()
        .onAppear{ getCloseTo() }
    }
}



struct SwipeLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeLocationsView(title: "Kult", subDescription: "Bar",  locationProfileURL: "https://firebasestorage.googleapis.com/v0/b/meet-a-friend-1b475.appspot.com/o/mtfllcrbrNqqiknl0FfO.jpg?alt=media&token=0111c1ae-bb29-47a5-97df-f43cfd86a35d", locationID: "bla")
            .environmentObject(MapServiceImpl())
            .environmentObject(LocationServiceImpl())
    }
}
