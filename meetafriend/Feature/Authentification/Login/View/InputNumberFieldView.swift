//
//  InputNumberFieldView.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import SwiftUI

struct InputNumberFieldView: View {
    @Binding var text: Int
    let placeholder: String
    let keyboardType: UIKeyboardType
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 35
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
    var body: some View {
        TextField("", value: $text, formatter: formatter)
            .foregroundColor(Color("MAFwhite"))
            .frame(minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
            .keyboardType(keyboardType)
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

struct InputNumberFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputTextFieldView(text: .constant(""),
                               placeholder: "Age",
                               keyboardType: .decimalPad,
                               sfSymbol: "envelope")
            .preview(with: "Email Text Input with sfsymbol")
            
            InputTextFieldView(text: .constant(""),
                               placeholder: "Age",
                               keyboardType: .decimalPad,
                               sfSymbol: nil)
            .preview(with: "Age Number Input with Placeholder")
            
        }
    }
}
