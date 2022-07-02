//
//  ChatMessageView.swift
//  meetafriend
//
//  Created by Luca on 13.05.22.
//

import SwiftUI
import SDWebImageSwiftUI


struct ChatMessageView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    let user: User
    let message: Message
    let fromSelf: Bool
    
    @State var read = true
    
    init(recentMessage: RecentMessage) {
        self.user = recentMessage.chatUser
        self.message = recentMessage.recentMessage
        self.fromSelf = recentMessage.fromSelf
    }
    
    var body: some View {
        if (read) {
            HStack() {
                WebImage(url: URL(string: user.profilePictureURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 50)
                        .stroke(Color(.black), lineWidth: 1)
                    )


                VStack(alignment: .leading) {
                    Text(user.firstName)
                        .font(.system(size: 16, weight: .bold))
                    
                    HStack {
                        if (fromSelf) {
                            Image(systemName: "arrow.turn.down.right")
                        }
                        
                        Text(message.text)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }
                    
                }
                .padding(.leading, 5)
                    
                
                Spacer()
                
                
                VStack(alignment: .trailing) {
                    Text(message.timestamp.dateValue().formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 14, weight: .medium))
                    Text(message.timestamp.dateValue().formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.leading, 5)
                
            
            }
            .padding()
        } else {
            ZStack {
                HStack() {
                    WebImage(url: URL(string: user.profilePictureURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.black), lineWidth: 1)
                        )


                    VStack(alignment: .leading) {
                        Text(user.firstName)
                            .font(.system(size: 16, weight: .bold))
                        
                        HStack {
                            Image(systemName: "arrow.turn.down.right")
                            
                            Text(message.text)
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        
                    }
                    .padding(.leading, 5)
                        
                    
                    Spacer()
                    
                    
                    VStack(alignment: .trailing) {
                        Text(message.timestamp.dateValue().formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 14, weight: .medium))
                        Text(message.timestamp.dateValue().formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.leading, 5)
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

