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
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading) {
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
                
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 400)
            .background(Color("MAFyellow"))
            .cornerRadius(25)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Sign up")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.leading, 10)
            .padding(.top, 30)
            
                
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
            
            Spacer()
            
            HStack {
                Spacer()
                
                ButtonView(title: "join", background: Color("MAFgray")) {
                    if self.image != nil {
                        registerService.image = self.image
                    }
                    registerService.register()
                }
                .frame(maxWidth: 100)
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /*
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                InputTextFieldView(text: $vm.credentials.email,
                                   placeholder: "Email",
                                   keyboardType: .emailAddress,
                                   sfSymbol: "envelope")
                
                InputPasswordView(password: $vm.credentials.password,
                                  placeholder: "Password",
                                  sfSymbol: "lock")
            }
            
            HStack {
                Spacer()
                Button(action: {
                    showForgotPassword.toggle()
                }, label: {
                    Text("Forgot Password?")
                })
                .font(.system(size: 16, weight: .bold))
                .sheet(isPresented: $showForgotPassword,
                       content: {
                    ForgotPasswordView()
                })
            }
            
            VStack(spacing: 16) {
                ButtonView(title: "Login") {
                    vm.login()
                }
                
                ButtonView(title: "Register",
                        background: .clear,
                        foreground: .blue,
                        border: .blue) {
                    showRegistration.toggle()
                }
                .sheet(isPresented: $showRegistration,
                       content: {
                    RegisterView()
                })
            }
        }
        .padding(.horizontal, 15)
        .navigationTitle("Login")
        .alert(isPresented: $vm.hasError,
               content: {
            if case .failed(let error) = vm.state {
                return Alert(title: Text("Error"),
                             message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text("Error"),
                             message: Text("Something went wrong"))
            }
        })
    }
     */
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
