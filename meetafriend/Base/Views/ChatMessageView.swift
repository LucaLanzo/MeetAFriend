//
//  ChatMessageView.swift
//  meetafriend
//
//  Created by Luca on 13.05.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI
import SDWebImageSwiftUI


struct ChatMessageView: View {
    
    let user: User
    let message: String
    let time: Int
    
    @State var read = true
    
    var body: some View {
        if (read) {
            HStack() {
                WebImage(url: URL(string: user.profilePictureURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipped()
                    .cornerRadius(50)


                VStack(alignment: .leading) {
                    HStack {
                        Text(user.firstName)
                            .font(.system(size: 16, weight: .bold))
                        
                        Spacer()
                        
                        Text(String(time))
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                }
                
                Spacer()
                
            }
            .padding()
        } else {
            ZStack {
                HStack() {
                    WebImage(url: URL(string: user.profilePictureURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipped()
                        .cornerRadius(50)


                    VStack(alignment: .leading) {
                        HStack {
                            Text(user.firstName)
                                .font(.system(size: 16, weight: .bold))
                            
                            Spacer()
                            
                            Text(String(time))
                                .font(.system(size: 14, weight: .semibold))
                        }
                        Text(message)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }
                    
                    Spacer()

                }
                .padding()
                .background(.white)
                .cornerRadius(25)
                .shadow(radius: 10)
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 0)
        }
    }
}

