//
//  LoginView.swift
//  meetafriend
//
//  Created by Luca on 21.03.22.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var registerService = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )
    
    @StateObject private var loginService = LoginViewModelImpl(
            service: LoginServiceImpl()
        )
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var showRegistration = false
    
    var body: some View {
        VStack(alignment: .leading) {
            logo
            
            Spacer()
            
            logOrReg
            
            Spacer()
            
            if (!showRegistration) {
                logView
                Spacer()
                logButton
            } else {
                regView
                Spacer()
                regButton
            }
        }
        .navigationBarHidden(true)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented: $loginService.hasError,
               content: {
            if case .failed(let error) = loginService.state {
                return Alert(title: Text("Error"),
                             message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text("Error"),
                             message: Text("Something went wrong"))
            }
        })
        .alert(isPresented: $registerService.hasError,
              content: {
            if case .failed(let error) = registerService.state {
                return Alert(title: Text("Error"),
                             message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text("Error"),
                             message: Text("Something went wrong"))
            }
            
        })
        .gesture(
            TapGesture()
                .onEnded { _ in
                    hideKeyboard()
                }
        )
    }
    
    
    private var logo: some View {
        VStack {
            HStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                                        
                Text("meet a friend")
                    .font(.title3)
            }
            .frame(maxWidth: 160)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .clipShape(RoundedRectangle(cornerSize: .zero))
            .background(Color("MAFwhite"))
            .cornerRadius(25)
            .shadow(radius: 7)
            
            Spacer()
            
            VStack {
                Image("IntroFriend")
                    .resizable()
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .scaledToFit()
                    .background(Color("MAFIntroPicture"))
                    .frame(width: 160)
                    .clipShape(Circle())
            
            }
            .shadow(radius: 7)
            
            Spacer()
            
            Text("A great way to\nfind new friends")
                .foregroundColor(Color("MAFblack"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 440)
        .background(Color("MAFyellow"))
        .cornerRadius(25)
    }
    
    private var logOrReg: some View {
        Button {
            showRegistration.toggle()
        } label: {
            HStack {
                if (!showRegistration) {
                    Text("Login")
                    .underline()
                    .font(.title)
                    .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("Register")
                        .font(.title)
                        .fontWeight(.bold)
                        .opacity(0.5)
                } else {
                    Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("Register")
                        .underline()
                        .font(.title)
                        .fontWeight(.bold)
                        .opacity(1)
                }
                
            }
            .padding()
            .padding(.horizontal, 40)
        }
        .buttonStyle(.plain)
    }
    
    private var logView: some View {
        VStack {
            InputTextFieldView(text: $loginService.credentials.email,
                               placeholder: "Email",
                               keyboardType: .emailAddress,
                               sfSymbol: "envelope")
            
            InputPasswordView(password: $loginService.credentials.password,
                              placeholder: "Password",
                              sfSymbol: "lock")
        }
        .padding()
        .background(Color("MAFgray"))
        .frame(maxWidth: .infinity)
        .cornerRadius(25)
    }
    
    private var regView: some View {
            
        HStack {
            VStack {
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25, height: 25)
                                .cornerRadius(64)
                        } else {
                            Image(systemName: "person.fill")
                                .colorInvert()
                                .font(.system(size: 25))
                                .padding()
                                .foregroundColor(Color(.label))
                        }
                }
                .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color("MAFwhite"), lineWidth: 1)
                )
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                        .ignoresSafeArea()
                }
                
                InputTextFieldView(text: $registerService.userDetails.email,
                                   placeholder: "Email",
                                   keyboardType: .emailAddress,
                                   sfSymbol: "envelope")
                
                InputPasswordView(password: $registerService.userDetails.password,
                                  placeholder: "Password",
                                  sfSymbol: "lock")
                
            }
            
            
            
            VStack {
                Spacer()
                
                InputTextFieldView(text: $registerService.userDetails.firstName,
                                   placeholder: "First Name",
                                   keyboardType: .namePhonePad,
                                   sfSymbol: nil)
                
                InputTextFieldView(text: $registerService.userDetails.lastName,
                                   placeholder: "Last Name",
                                   keyboardType: .namePhonePad,
                                   sfSymbol: nil)
                
                
                InputNumberFieldView(text: $registerService.userDetails.age,
                                   placeholder: "Age",
                                   keyboardType: .decimalPad,
                                   sfSymbol: nil)
            }
        }
        .padding()
        .background(Color("MAFgray"))
        .frame(maxWidth: .infinity, maxHeight: 190)
        .cornerRadius(25)
        
    }
    
    private var logButton: some View {
        HStack {
            Spacer()
            
            ButtonView(title: "login", background: Color("MAFgray")) {
                loginService.login()
            }
            .frame(maxWidth: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
    
    private var regButton: some View {
        HStack {
            Spacer()
            
            ButtonView(title: "join", background: Color("MAFgray")) {
                if self.image != nil {
                    registerService.image = self.image
                }
                registerService.register()
                hideKeyboard()
            }
            .frame(maxWidth: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
