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


                VStack(alignment: .leading) {
                    Text(user.firstName)
                        .font(.system(size: 16))
                        .foregroundColor(Color("MAFblack"))
                    
                    HStack {
                        if (fromSelf) {
                            Image(systemName: "arrow.turn.down.right")
                                .foregroundColor(Color("MAFblack"))
                        }
                        
                        Text(message.text)
                            .font(.system(size: 14))
                            .foregroundColor(Color("MAFblack"))
                            .opacity(50)
                            .truncationMode(.tail)
                    }
                    
                }
                .padding(.leading, 10)
                    
                
                Spacer()
                
                
                VStack(alignment: .trailing) {
                    Text(message.timestamp.dateValue().formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("MAFblack"))
                    Text(message.timestamp.dateValue().formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("MAFblack"))
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


                    VStack(alignment: .leading) {
                        Text(user.firstName)
                            .font(.system(size: 16))
                            .foregroundColor(Color("MAFblack"))
                        
                        HStack {
                            Image(systemName: "arrow.turn.down.right")
                                .foregroundColor(Color("MAFblack"))
                            
                            Text(message.text)
                                .font(.system(size: 14))
                                .foregroundColor(Color("MAFgray"))
                                .opacity(50)
                                .truncationMode(.tail)
                        }
                        
                    }
                    .padding(.leading, 10)
                        
                    
                    Spacer()
                    
                    
                    VStack(alignment: .trailing) {
                        Text(message.timestamp.dateValue().formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("MAFblack"))
                        Text(message.timestamp.dateValue().formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("MAFblack"))
                    }
                    .padding(.leading, 5)
                }
                .padding()
                .background(Color("MAFwhite"))
                .cornerRadius(25)
                .shadow(radius: 10)
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 0)
        }
    }
}

