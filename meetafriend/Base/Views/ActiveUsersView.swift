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
                    ZStack {
                        VStack {
                            Text(username)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Text("\(age) years old")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Image(systemName: "message")
                                .font(.system(size: 32))
                                .padding(8)
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(.label))
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .frame(width: 150, height: 170)
                        .background(.black)
                        .cornerRadius(15)
                        
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .frame(width: 48, height: 48)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.black), lineWidth: 1))
                            .offset(x: -20, y: -100)
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
                        .frame(width: 48, height: 48)
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.black), lineWidth: 1))
                    
                    VStack {
                        Text(username)
                            .font(.system(size: 28, weight: .bold))
                            .rotationEffect(.degrees(-90))
                            .fixedSize()
                            .frame(width: 20, height: 140)
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
