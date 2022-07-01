//
//  ChatOverviewView.swift
//  meetafriend
//
//  Created by Luca on 12.05.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatOverviewView: View {
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
                    
                    Text("\(chatOverviewService.location?.name ?? "")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                }
                
                Spacer()
                
                WebImage(url: URL(string: chatOverviewService.location?.locationPictureURL ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipped()
                        .cornerRadius(50)
                
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
    
            
            
            if (chatOverviewService.users.count == 0) {
                VStack(alignment: .center) {
                    Text("No active users")
                        .font(.title2)
                    Text("at this location")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                .padding([.leading, .trailing])
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chatOverviewService.users) { user in
                            ActiveUsersView(user: user)
                                .padding()
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            
            
            // Messages
            VStack(alignment: .leading, spacing: 16) {
                Text("Messages")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding([.leading, .trailing])
            
            
            
            ScrollView {
                /*
                ForEach(chatOverviewService.recentMessages) { message in
                    NavigationLink(destination: ChatView(chatUser: user, lid: chatOverviewService.location?.id)) {
                        ChatMessageView(user: User, message: message, time: message.timestamp)
                    }
                    .buttonStyle(.plain)
                }
                 */
            }
        }
        .navigationBarHidden(true)
        .padding([.leading, .trailing], 10)
        .onAppear {
            self.chatOverviewService.getJoinedLocation()
        }
    }
        
}

struct ChatOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatOverviewView()
                .environmentObject(LocationServiceImpl())
                .environmentObject(ChatOverviewServiceImpl())
        }
        .previewInterfaceOrientation(.portrait)
    }
}
