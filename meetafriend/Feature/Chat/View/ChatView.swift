//
//  ChatView.swift
//  meetafriend
//
//  Created by Luca on 12.05.22.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var locationService: LocationServiceImpl
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // Menu Bar
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(.label))
                
                Spacer()
                
                VStack {
                    Text("You're at")
                        .multilineTextAlignment(.center)
                    Text("Kult")
                        .multilineTextAlignment(.center)
                }
                Spacer()
                
                Image(systemName: "")
                    .font(.system(size: 32))
                    .padding(15)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth: 1))
            }
            .padding([.leading, .trailing])
            
            
            // Active
            VStack(alignment: .leading, spacing: 16) {
                Text("Active")
                    .font(.title)
            }
            .padding([.leading, .trailing])
    
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<10, id: \.self) { num in
                        ActiveUsersView(username: "Luca", age: String(23))
                            .padding()
                    }
                }
            }
            .padding([.leading, .trailing])
            
            // Messages
            VStack(alignment: .leading, spacing: 16) {
                Text("Messages")
                    .font(.title)
            }
            .padding([.leading, .trailing])
            
            
            VStack() {
                ScrollView {
                    ForEach(0..<10, id: \.self) { num in
                        ChatMessageView(username: "Luca", message: "Test message", time: "3m")
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationServiceImpl())
        }
        .previewInterfaceOrientation(.portrait)
    }
}
