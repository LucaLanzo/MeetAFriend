//
//  ActiveUsersView.swift
//  meetafriend
//
//  Created by Luca on 13.05.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActiveUsersView: View {
    @State var isClicked = true
    
    var user: User?
    
    var body: some View {
        if isClicked {
            Button {
                isClicked.toggle()
            } label: {
                    ZStack {
                        VStack {
                            Text(user?.firstName ?? "First Name")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Text("\(user?.age ?? 20) years old")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Image(systemName: "message")
                                .font(.system(size: 32))
                                .padding(8)
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(.label))
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .frame(width: 150, height: 170)
                        .background(.black)
                        .cornerRadius(15)
                        
                        WebImage(url: URL(string: user?.profilePictureURL ?? "gs://meet-a-friend-1b475.appspot.com/6kjhC6xEsmfTnhf8Cd6edilCeNq1"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipped()
                            .cornerRadius(50)
                            .offset(x: -20, y: -100)
                    }
            }
            .buttonStyle(.plain)
        } else {
            Button {
                isClicked.toggle()
            } label: {
                VStack {
                    WebImage(url: URL(string: user?.profilePictureURL ?? "gs://meet-a-friend-1b475.appspot.com/6kjhC6xEsmfTnhf8Cd6edilCeNq1"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipped()
                        .cornerRadius(50)
                    
                    VStack {
                        Text(user?.firstName ?? "First Name")
                            .font(.system(size: 28, weight: .bold))
                            .rotationEffect(.degrees(-90))
                            .fixedSize()
                            .frame(width: 20, height: 140)
                    }
                    .frame(width: 40)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct ActiveUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveUsersView(user: nil)
    }
}
