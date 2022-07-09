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
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var locationService: LocationServiceImpl
    @StateObject var chatService: ChatService
    
    let chatUser: User

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
        .gesture(
            TapGesture()
                .onEnded { _ in
                    hideKeyboard()
                }
        )
        .onAppear {
            print("Service: \(chatService.chatUser.firstName)")
            print("UI: \(chatUser.firstName)")
        }
        
    }
    
    private var menuBar: some View {
        // Menu Bar
        HStack {
            NavigationLink(destination: ChatOverviewView()) {
                backButton
            }
            .buttonStyle(.plain)
            
            
            Spacer()
            
            VStack {
                Text(chatUser.firstName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("MAFwhite"))
                    .multilineTextAlignment(.center)
                
            }
            
            Spacer()
            
            WebImage(url: URL(string: chatUser.profilePictureURL))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipped()
                .cornerRadius(50)
            
        }
        .padding()
        .background(Color("MAFyellow"))
        .cornerRadius(20)
        
    }
    
    private var backButton: some View {
        Image(systemName: "chevron.backward")
            .font(.system(size: 20, weight: .bold))
            .frame(width: 48, height: 48)
            .foregroundColor(Color("MAFblack"))
            .background(Color("MAFwhite"))
            .clipShape(Circle())
            .shadow(radius: 5)
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
                                        .foregroundColor(Color("MAFwhite"))
                                }
                                .padding(10)
                                .background(Color("MAFgray"))
                                .cornerRadius(13, corners: [.topRight, .bottomLeft, .bottomRight])
                                .shadow(radius: 2)
                                
                                WebImage(url: URL(string: sessionService.userDetails?.profilePictureURL ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipped()
                                        .cornerRadius(50)
                                        .shadow(radius: 2)
                            }
                        } else {
                            HStack {
                                WebImage(url: URL(string: chatUser.profilePictureURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipped()
                                        .cornerRadius(50)
                                        .shadow(radius: 2)
                                
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(Color("MAFwhite"))
                                }
                                .padding(10)
                                .background(Color("MAFyellow"))
                                .cornerRadius(13, corners: [.topLeft, .bottomLeft, .bottomRight])
                                .shadow(radius: 2)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                
                }
                
                HStack{ Spacer() }
            }
        }
    }
    
    
    private var chatBottomBar: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "face.smiling")
                .font(.system(size: 24))
                .foregroundColor(Color("MAFwhite"))
            
            InputMessageView(text: $chatService.text,
                               placeholder: "Type a message",
                               keyboardType: .default)
            
            Button {
                if (!chatService.text.isEmpty) {
                    chatService.sendMessage()
                }
            } label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 24))
                    .foregroundColor(Color("MAFwhite"))
                    .padding(5)
            }
            .buttonStyle(.plain)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color("MAFgray"))
        .cornerRadius(20)
        .shadow(radius: 7)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

