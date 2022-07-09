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
                        .foregroundColor(Color("MAFblack"))
                        .background(Color("MAFwhite"))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                })
                
                Spacer()
                
                VStack {
                    Text("You're at")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("MAFblack"))
                    
                    Text("\(chatOverviewService.location?.name ?? "")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MAFwhite"))
                        .multilineTextAlignment(.center)
                    
                }
                
                Spacer()
                
                WebImage(url: URL(string: chatOverviewService.location?.locationPictureURL ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipped()
                        .cornerRadius(50)
                        .shadow(radius: 5)
                
            }
            .padding()
            .background(Color("MAFyellow"))
            .cornerRadius(20)
            
            
            
            // Active
            VStack(alignment: .leading, spacing: 16) {
                Text("Active")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("MAFblack"))
            }
            .padding([.leading, .trailing, .top])
            
            
            if (chatOverviewService.users.count != 0) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chatOverviewService.users) { user in
                            ActiveUsersView(user: user)
                                .padding()
                        }
                    }
                }
                .padding([.leading, .trailing])
                
            } else {
                
                VStack(alignment: .center) {
                    VStack() {
                        Text("Hm, no one is")
                            .font(.title2)
                            .foregroundColor(Color("MAFwhite"))
                        Text("here right now...")
                            .font(.title2)
                            .foregroundColor(Color("MAFwhite"))
                        Image(systemName: "eyes")
                            .foregroundColor(Color("MAFwhite"))
                            .padding()
                    }
                    .padding(20)
                    .background(Color("MAFgray"))
                    .cornerRadius(20)
                }
                .frame(maxWidth: .infinity, maxHeight: 180)
                .padding([.leading, .trailing])
            }
            
            
            // Messages
            VStack(alignment: .leading, spacing: 16) {
                Text("Messages")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("MAFblack"))
            }
            .padding([.leading, .trailing, .top])
            
            if (chatOverviewService.recentMessages.count != 0) {
                
                ScrollView {
                    
                    ForEach(chatOverviewService.recentMessages) { recentMessage in
                        NavigationLink(destination:
                                        ChatView(chatService: ChatService(recentMessage.chatUser, chatOverviewService.location!.id!),
                                                 chatUser: recentMessage.chatUser)) {
                            
                            ChatMessageView(recentMessage: recentMessage)
                        }
                        .buttonStyle(.plain)
                    }
                    
                }
                    
            } else {
                VStack(alignment: .center) {
                    VStack() {
                        Text("No active chats")
                            .font(.title2)
                            .foregroundColor(Color("MAFwhite"))
                        Text("start chatting now!")
                            .font(.title2)
                            .foregroundColor(Color("MAFwhite"))
                        Image(systemName: "scribble.variable")
                            .foregroundColor(Color("MAFwhite"))
                            .padding()
                    }
                    .padding(20)
                    .background(Color("MAFgray"))
                    .cornerRadius(20)
                }
                .frame(maxWidth: .infinity, maxHeight: 180)
                .padding([.leading, .trailing])
                
                Spacer()
            }
            
            
        }
        .navigationBarHidden(true)
        .padding(.horizontal, 8)
        .onAppear {
            self.chatOverviewService.getJoinedLocation()
        }
    }
        
}

struct ChatOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ChatOverviewView()
            .environmentObject(LocationServiceImpl())
            .environmentObject(ChatOverviewServiceImpl())
    }
}
