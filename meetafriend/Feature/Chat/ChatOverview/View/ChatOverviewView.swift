//
//  ChatOverviewView.swift
//  meetafriend
//
//  Created by Luca on 12.05.22.
//

import SwiftUI

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
                    Text("Kult")
                        .font(.largeTitle)
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
                ChatMessageView(username: "Luca", message: "Test message", time: "3m", read: false)
                ForEach(0..<10, id: \.self) { num in
                    ChatMessageView(username: "Luca", message: "Test message", time: "3m", read: true)
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
