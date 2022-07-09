//
//  IntroductionView.swift
//  meetafriend
//
//  Created by Luca on 02.07.22.
//

import SwiftUI

struct IntroductionView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("IntroFriends")
                        .resizable()
                        .padding(EdgeInsets(top: 45, leading: 75, bottom: 45, trailing: 65))
                        .scaledToFit()
                        .background(Color("MAFIntroPicture"))
                        .clipShape(Circle())
                
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .shadow(radius: 7)
                
                Spacer()
                
                VStack {
                    Text("Go to a\nlocation near\nyou and start\nchatting with\nstrangers")
                        .foregroundColor(Color("MAFblack"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .fixedSize()
                
                Spacer()
                
                VStack (alignment: .center) {
                    NavigationLink(destination: LoginView()) {
                        GetStartedButtonView()
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 30)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("MAFyellow"))
            .navigationBarHidden(true)
        }
    }
}

struct GetStartedButtonView: View {
    var body: some View {
        VStack {
            Text("get started")
                .fontWeight(.bold)
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .foregroundColor(Color("MAFwhite"))
                .background(RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(Color("MAFgray"))
                )
        }
        .shadow(radius: 5)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
