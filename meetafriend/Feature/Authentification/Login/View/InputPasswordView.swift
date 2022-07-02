//
//  InputPasswordView.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import SwiftUI

struct InputPasswordView: View {
    @Binding var password: String
    let placeholder: String
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 35
    
    var body: some View {
        SecureField("", text: $password)
            .placeholder(when: password.isEmpty) {
                   Text(placeholder).foregroundColor(Color("MAFwhite"))
            }
            .foregroundColor(Color("MAFwhite"))
            .frame(minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2: textFieldLeading)
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


struct InputPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        InputPasswordView(password: .constant(""),
                          placeholder: "Password",
                            sfSymbol: "lock")
        .preview(with: "Input Password View with sfsymbol")
        
        InputPasswordView(password: .constant(""),
                          placeholder: "Password",
                            sfSymbol: nil)
        .preview(with: "Input Password View without sfsymbol")
    }
}
