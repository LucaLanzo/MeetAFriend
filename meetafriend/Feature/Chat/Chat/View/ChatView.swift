//
//  ChatView.swift
//  meetafriend
//
//  Created by Luca on 18.05.22.
//

import SwiftUI



struct ChatView: View {
    var name: String
    @State var message: String
    @EnvironmentObject var chatService: ChatServiceImpl
    
    var body: some View {
        VStack(alignment: .leading) {
            // Menu Bar
            HStack {
                NavigationLink(destination: ChatOverviewView()) {
                    Image(systemName: "chevron.backward.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .shadow(radius: 8)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                VStack {
                    Text(name)
                        .font(.title)
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
            
            Spacer()
            
            VStack () {
                Text("Message")
            }
            
            Spacer()
            
            HStack {
                InputTextFieldView(text: $message, placeholder: "type a message", keyboardType: .default, sfSymbol: nil)
            }
            
            
        }
        .navigationBarHidden(true)
        .padding([.leading, .trailing], 10)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(name: "Steffi", message: "")
    }
}
