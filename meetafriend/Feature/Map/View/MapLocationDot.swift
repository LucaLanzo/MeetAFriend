//
//  MapLocationDot.swift
//  meetafriend
//
//  Created by Luca on 13.06.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MapLocationDot: View {
    let locationProfileURL: String
    
    @State var isClicked = false
    
    var body: some View {
       
        WebImage(url: URL(string: locationProfileURL))
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 48)
            .clipped()
            .cornerRadius(50)
            .overlay(RoundedRectangle(cornerRadius: 50)
                .stroke(Color("MAFyellow"), lineWidth: 2)
            )
        
        
        
    }
}

struct MapLocationDot_Previews: PreviewProvider {
    static var previews: some View {
        MapLocationDot(locationProfileURL: "https://firebasestorage.googleapis.com/v0/b/meet-a-friend-1b475.appspot.com/o/mtfllcrbrNqqiknl0FfO.jpg?alt=media&token=0111c1ae-bb29-47a5-97df-f43cfd86a35d")
    }
}
