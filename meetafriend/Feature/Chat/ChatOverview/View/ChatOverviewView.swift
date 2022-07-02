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
                        .shadow(radius: 7)
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
                        .shadow(radius: 7)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.black), lineWidth: 1)
                        )
                
            }
            .padding()
            .background(.yellow)
            .cornerRadius(20)
            
            
            
            // Active
            VStack(alignment: .leading, spacing: 16) {
                Text("Active")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding([.leading, .trailing, .top])
            
            
            if (chatOverviewService.users.count == 0) {
                VStack(alignment: .center) {
                    VStack() {
                        Text("Hm, no one is")
                            .font(.title2)
                        Text("here right now...")
                            .font(.title2)
                        Image(systemName: "eyes")
                            .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20,
                                             style: .continuous)
                            .stroke(Color.gray)
                            .padding(-15)
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: 180)
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
            .padding([.leading, .trailing, .top])
            
            if (chatOverviewService.recentMessages.count == 0) {
                
                VStack(alignment: .center) {
                    VStack() {
                        Text("No active chats")
                            .font(.title2)
                        Text("start chatting now!")
                            .font(.title2)
                        Image(systemName: "scribble.variable")
                            .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20,
                                             style: .continuous)
                            .stroke(Color.gray)
                            .padding(-15)
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: 180)
                .padding([.leading, .trailing])
                
                Spacer()
            } else {
                ScrollView {
                    
                    ForEach(chatOverviewService.recentMessages) { recentMessage in
                        NavigationLink(destination: ChatView(chatUser: recentMessage.chatUser)) {
                            ChatMessageView(recentMessage: recentMessage)
                        }
                        .buttonStyle(.plain)
                    }
                    
                }
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
