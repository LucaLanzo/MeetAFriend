//
//  InputMessageView.swift
//  meetafriend
//
//  Created by Luca on 09.07.22.
//

import SwiftUI

struct InputMessageView: View {
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    private let textFieldLeading: CGFloat = 35
    
    var body: some View {
        
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                   Text(placeholder).foregroundColor(Color("MAFwhite"))
            }
            .foregroundColor(Color("MAFwhite"))
            .padding(.leading, textFieldLeading / 2)
            .keyboardType(keyboardType)
            .autocapitalization(UITextAutocapitalizationType.none)
    }
}

struct InputMessageView_Previews: PreviewProvider {
    static var previews: some View {
        InputMessageView(text: .constant(""),
                           placeholder: "Type a message",
                           keyboardType: .default)
        
    }
}
