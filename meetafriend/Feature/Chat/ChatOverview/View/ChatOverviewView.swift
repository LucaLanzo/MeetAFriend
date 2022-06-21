//
//  ChatOverviewView.swift
//  meetafriend
//
//  Created by Luca on 12.05.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatOverviewView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var locationService: LocationServiceImpl
    @EnvironmentObject var chatOverviewService: ChatOverviewServiceImpl
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // Menu Bar
            HStack {
                Button(action: {
                    locationService.leaveLocation()
                }, label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color(.label))
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                })
                
                Spacer()
                
                VStack {
                    Text("You're at")
                        .multilineTextAlignment(.center)
                    if let location = locationService.joinedLocation {
                        Text(location.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("a location")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                
                if let location = locationService.joinedLocation {
                    WebImage(url: URL(string: location.locationPictureURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 50))
                } else {
                    Image(systemName: "")
                        .font(.system(size: 32))
                        .frame(width: 18, height: 18)
                        .padding(15)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(.label), lineWidth: 1))
                }
            }
            .padding()
            .background(.yellow)
            .cornerRadius(15)
            
            
            
            // Active
            VStack(alignment: .leading, spacing: 16) {
                Text("Active")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding([.leading, .trailing])
    
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(chatOverviewService.users) { user in
                        ActiveUsersView(username: user.firstName, age: String(user.age))
                            .padding()
                    }
                }
            }
            .padding([.leading, .trailing])
            
            
            
            // Messages
            VStack(alignment: .leading, spacing: 16) {
                Text("Messages")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding([.leading, .trailing])
            
            
            
            ScrollView {
                ForEach(chatOverviewService.users) { user in
                    NavigationLink(destination: ChatView(chatUser: user)) {
                        ChatMessageView(username: user.firstName, message: "Test message", time: "3m", read: true)
                    }
                    .buttonStyle(.plain)
                }
            }
            
        }
        .navigationBarHidden(true)
        .padding([.leading, .trailing], 10)
    }
}

struct ChatOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatOverviewView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationServiceImpl())
                .environmentObject(ChatOverviewServiceImpl())
        }
        .previewInterfaceOrientation(.portrait)
    }
}
