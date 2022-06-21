//
//  ChatView.swift
//  meetafriend
//
//  Created by Luca on 18.05.22.
//

import SwiftUI
import FirebaseAuth


struct ChatView: View {
    @EnvironmentObject var chatService: ChatServiceImpl
    
    let chatUser: User?
        
    init(chatUser: User?) {
        self.chatUser = chatUser
    }
    
    func setChatUser() {
        self.chatService.chatUser = chatUser
        self.chatService.fetchMessages()
        print("Chat View: Set chat user to: \(chatUser?.firstName ?? "No user found")")
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
        .onAppear{ setChatUser() }
    }
    
    
    private var menuBar: some View {
        // Menu Bar
        HStack {
            NavigationLink(destination: ChatOverviewView()) {
                Image(systemName: "chevron.backward.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .shadow(radius: 8)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            VStack {
                Text(chatUser?.firstName ?? "Placeholder")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Image(systemName: "")
                .font(.system(size: 32))
                .frame(width: 18, height: 18)
                .padding(15)
                .overlay(RoundedRectangle(cornerRadius: 44)
                .stroke(Color(.label), lineWidth: 1))
        }
        .padding()
        .background(.yellow)
        .cornerRadius(15)
        
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
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.white))
            ZStack {
                //DescriptionPlaceholder()
                TextEditor(text: $chatService.text)
                    .background(Color.gray)
                    .opacity(chatService.text.isEmpty ? 0.5 : 1)
            }
            .frame(height: 30)
            
            Button {
                chatService.sendMessage()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .background(Color.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray)
        .cornerRadius(15)
    }
    
    
    private struct DescriptionPlaceholder: View {
        var body: some View {
            HStack {
                Text("Description")
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                    .padding(.leading, 5)
                    .padding(.top, -4)
                Spacer()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatUser: nil)
            .environmentObject(ChatServiceImpl())
    }
}
