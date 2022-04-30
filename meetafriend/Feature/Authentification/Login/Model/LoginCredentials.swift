//
//  LoginCredentials.swift
//  meetafriend
//
//  Created by Luca on 28.03.22.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}

extension LoginCredentials {
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
