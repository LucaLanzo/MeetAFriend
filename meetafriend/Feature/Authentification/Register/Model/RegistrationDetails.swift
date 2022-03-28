//
//  RegistrationDetails.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import Foundation

struct RegistrationDetails {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    // Should be int!!!
    var age: String
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(email: "", password: "", firstName: "", lastName: "", age: "")
    }
}
