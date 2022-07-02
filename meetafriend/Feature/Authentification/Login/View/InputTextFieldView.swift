//
//  InputTextFieldView.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import SwiftUI

struct InputTextFieldView: View {
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 35
    
    var body: some View {
        
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                   Text(placeholder).foregroundColor(Color("MAFwhite"))
            }
            .foregroundColor(Color("MAFwhite"))
            .frame(minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
            .keyboardType(keyboardType)
            .autocapitalization(UITextAutocapitalizationType.none)
            .disableAutocorrection(true)
            .background(
                
                ZStack(alignment: .leading) {
                    if let systemImage = sfSymbol {
                        Image(systemName: systemImage)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 7)
                            .foregroundColor(Color("MAFwhite"))
                    }
                    
                    RoundedRectangle(cornerRadius: 10,
                                     style: .continuous)
                    .stroke(Color("MAFwhite"))
                }
            )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct InputTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputTextFieldView(text: .constant(""),
                               placeholder: "Email",
                               keyboardType: .emailAddress,
                               sfSymbol: "envelope")
            .preview(with: "Email Text Input with sfsymbol")
            
            InputTextFieldView(text: .constant(""),
                               placeholder: "First Name",
                               keyboardType: .default,
                               sfSymbol: nil)
            .preview(with: "First Name Text Input with sfsymbol")
            
        }
        .background(Color("MAFgray"))
    }
}
