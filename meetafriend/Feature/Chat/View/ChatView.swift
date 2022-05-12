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
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                ButtonView(title: "Leave Location") {
                    locationService.leaveLocation()
                }
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Chat")
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(LocationServiceImpl())
        }
    }
}
