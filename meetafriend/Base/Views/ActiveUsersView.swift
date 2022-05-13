//
//  ActiveUsersView.swift
//  meetafriend
//
//  Created by Luca on 13.05.22.
//

import SwiftUI

struct ActiveUsersView: View {
    let username: String
    let age: String
    @State var isClicked = false
    
    var body: some View {
        if isClicked {
            Button {
                isClicked.toggle()
            } label: {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                    
                    VStack(alignment: .leading) {
                        Text(username)
                            .font(.system(size: 28, weight: .bold))
                        Text(age)
                            .font(.system(size: 28, weight: .bold))
                        
                        Image(systemName: "message")
                            .font(.system(size: 32))
                            .padding(8)
                    }
                    .frame(width: 120, height: 170)
                    .background(.gray)
                    
                }
            }
            .buttonStyle(.plain)
        } else {
            Button {
                isClicked.toggle()
            } label: {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                    
                    VStack {
                        Text(username)
                            .font(.system(size: 28, weight: .bold))
                            .rotationEffect(.degrees(-90))
                            .fixedSize()
                            .frame(width: 20, height: 110)
                    }
                    .frame(width: 40)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct ActiveUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveUsersView(username: "Luca", age: String(23))
    }
}
