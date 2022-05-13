//
//  ChatMessageView.swift
//  meetafriend
//
//  Created by Luca on 13.05.22.
//

import SwiftUI

struct ChatMessageView: View {
    let username: String
    var message: String
    var time: String
    
    var body: some View {
        HStack() {
            Image(systemName: "person.fill")
                .font(.system(size: 32))
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1))


            VStack(alignment: .leading) {
                Text(username)
                    .font(.system(size: 16, weight: .bold))
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.lightGray))
            }
            Spacer()

            Text(time)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding()
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(username: "Luca", message: "Test message", time: "3m")
    }
}
