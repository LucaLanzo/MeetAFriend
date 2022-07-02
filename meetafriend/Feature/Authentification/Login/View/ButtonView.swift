//
//  ButtonComponentView.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import SwiftUI

struct ButtonView: View {
    
    typealias Actionhandler = () -> Void
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: Actionhandler
    
    private let cornerRadius: CGFloat = 20
    
    internal init(title: String,
                  background: Color = .blue,
                  foreground: Color = .white,
                  border: Color = .clear,
                  handler: @escaping ButtonView.Actionhandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 50)
        })
        .background(background)
        .foregroundColor(foreground)
        .font(.system(size: 16, weight: .bold))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 2)
        )
        
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "Primary") { }
            .preview(with: "Primary Button View")
        ButtonView(title: "Secondary",
                   background: .clear,
                   foreground: .blue,
                   border: .blue) { }
            .preview(with: "Secondary Button View")
    }
}
