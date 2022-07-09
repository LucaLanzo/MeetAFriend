//
//  MapLocationInfo.swift
//  meetafriend
//
//  Created by Luca on 13.06.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MapLocationInfo: View {
    let title: String
    let subDescription: String
    var locationProfileURL: String
    
    @State var canJoin = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack() {
                HStack() {
                    WebImage(url: URL(string: locationProfileURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color("MAFyellow"), lineWidth: 2)
                        )
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("MAFwhite"))
                        
                        Text(subDescription)
                            .fontWeight(.bold)
                            .foregroundColor(Color("MAFwhite"))
                    }
                    
                }
                .padding([.leading, .trailing], 30)
                .padding([.top, .bottom])
                
                Spacer()
                
                HStack() {
                    Text("")
                    
                    Spacer()
                    
                    if (canJoin) {
                        Button(action: {
                        }, label: {
                            Text("navigate")
                                .fontWeight(.bold)
                        })
                        .padding([.leading, .trailing], 30)
                        .padding([.top, .bottom], 10)
                        .buttonStyle(.plain)
                        .background(Color("MAFwhite"))
                        .cornerRadius(25)
                        .shadow(radius: 10)
                    } else {
                        Button(action: {
                        }, label: {
                            Text("enter")
                                .fontWeight(.bold)
                        })
                        .padding([.leading, .trailing], 30)
                        .padding([.top, .bottom], 10)
                        .buttonStyle(.plain)
                        .background(Color("MAFwhite"))
                        .cornerRadius(25)
                        .shadow(radius: 10)
                    }
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: 180)
            .background(Color("MAFgray"))
            .cornerRadius(30)
            
        }
        .frame(maxWidth: .infinity)
        .navigationBarHidden(true)
        .padding()
    }
}

struct MapLocationInfo_Previews: PreviewProvider {
    static var previews: some View {
        MapLocationInfo(title: "Tscharlie's", subDescription: "Café", locationProfileURL: "https://firebasestorage.googleapis.com/v0/b/meet-a-friend-1b475.appspot.com/o/mtfllcrbrNqqiknl0FfO.jpg?alt=media&token=0111c1ae-bb29-47a5-97df-f43cfd86a35d")
    }
}
