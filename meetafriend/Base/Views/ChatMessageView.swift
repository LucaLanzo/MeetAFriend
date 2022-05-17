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
    
    @State var read = false
    
    var body: some View {
        if (read) {
            HStack() {
                Image(systemName: "person.fill")
                    .font(.system(size: 32))
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1))


                VStack(alignment: .leading) {
                    HStack {
                        Text(username)
                            .font(.system(size: 16, weight: .bold))
                        
                        Spacer()
                        
                        Text(time)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                }
                
                Spacer()
                
            }
            .padding()
        } else {
            ZStack {
                HStack() {
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))


                    VStack(alignment: .leading) {
                        HStack {
                            Text(username)
                                .font(.system(size: 16, weight: .bold))
                            
                            Spacer()
                            
                            Text(time)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        Text(message)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }
                    
                    Spacer()

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

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            ScrollView {
                ChatMessageView(username: "Luca", message: "Test message", time: "3m", read: false)
                ForEach(0..<10, id: \.self) { num in
                    ChatMessageView(username: "Luca", message: "Test message", time: "3m", read: true)
                }
            }
        }
    }
}
