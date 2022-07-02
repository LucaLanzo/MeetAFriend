//
//  ChatView.swift
//  meetafriend
//
//  Created by Luca on 18.05.22.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI


struct ChatView: View {
    @EnvironmentObject var chatService: ChatServiceImpl
    @EnvironmentObject var locationService: LocationServiceImpl
    
    let chatUser: User?
        
    init(chatUser: User?) {
        self.chatUser = chatUser
    }
    

    var body: some View {
        VStack(alignment: .leading) {
            menuBar
                .padding(.bottom, 3)
            Spacer()
            messagesView
            Spacer()
            chatBottomBar
                .padding(.top, 3)
        }
        .navigationBarHidden(true)
        .padding([.leading, .trailing], 10)
        .onAppear {
            self.chatService.chatUser = chatUser	
            self.chatService.startNewChat()
        }
        .onDisappear {
            self.chatService.closeListenForMessages()
        }
    }
    
    
    private var menuBar: some View {
        // Menu Bar
        HStack {
            NavigationLink(destination: ChatOverviewView()) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color(.label))
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 7)
            }
            .buttonStyle(.plain)
            
            
            Spacer()
            
            VStack {
                Text(chatUser?.firstName ?? "Name")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
            }
            
            Spacer()
            
            WebImage(url: URL(string: chatUser?.profilePictureURL ?? "gs://meet-a-friend-1b475.appspot.com/6kjhC6xEsmfTnhf8Cd6edilCeNq1"))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipped()
                .cornerRadius(50)
            
        }
        .padding()
        .background(.yellow)
        .cornerRadius(20)
        
    }
    
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ForEach(chatService.messages) { message in
                    VStack {
                        if message.fromId == Auth.auth().currentUser?.uid {
                            HStack {
                                Spacer()
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                                .background(Color.gray)
                                .cornerRadius(8)
                            }
                        } else {
                            HStack {
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                                .background(Color.yellow)
                                .cornerRadius(8)
                                Spacer()
                            }
                        }
                    }
                
                }
                
                HStack{ Spacer() }
            }
        }
    }
    
    
    private var chatBottomBar: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "face.smiling")
                .font(.system(size: 24))
                .foregroundColor(Color(.white))
            
            TextField("Type a message", text: $chatService.text)
                .frame(height: 40)
                .foregroundColor(.white)
                .padding(.leading, 5)
            
            Button {
                if (!chatService.text.isEmpty) {
                    chatService.sendMessage()
                }
            } label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(5)
            }
            .buttonStyle(.plain)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray)
        .cornerRadius(20)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatUser: nil)
            .environmentObject(ChatServiceImpl())
            .environmentObject(LocationServiceImpl())
    }
}
