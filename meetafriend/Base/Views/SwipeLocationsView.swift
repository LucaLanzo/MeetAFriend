//
//  SwipeLocationsView.swift
//  meetafriend
//
//  Created by Luca on 17.05.22.
//

import SwiftUI

struct SwipeLocationsView: View {
    let title: String
    let subDescription: String
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(subDescription)
                        .fontWeight(.bold)
                    
                }
                .padding(30)
                
                Spacer()
                
                VStack {
                    Button(action: {
                    }, label: {
                        Text("enter")
                            .fontWeight(.bold)
                    })
                    .padding([.leading, .trailing], 30)
                    .padding([.top, .bottom], 10)
                    .buttonStyle(.plain)
                    .background(.yellow)
                    .cornerRadius(15)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Background Image
        }
        .frame(maxWidth: .infinity)
        .navigationBarHidden(true)
    }
}

struct SwipeLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeLocationsView(title: "Kult", subDescription: "Bar")
    }
}
