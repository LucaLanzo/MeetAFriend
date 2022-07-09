//
//  BottomPopupView.swift
//  meetafriend
//
//  Created by Luca on 08.07.22.
//


import SwiftUI

struct BottomPopupView<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                content
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .background(Color("MAFwhite"))
                    .cornerRadius(16)
            }
            .edgesIgnoringSafeArea([.bottom])
        }
        .animation(.easeOut)
        .transition(.move(edge: .bottom))
    }
}
