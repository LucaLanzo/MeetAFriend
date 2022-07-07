//
//  RegistrationDetails.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import FirebaseFirestoreSwift
import Foundation

struct RegistrationDetails: Codable {
    @DocumentID public var id: String?
    
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var age: Int
    var profilePictureURL: String
    var closeTo: Bool
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(email: "", password: "", firstName: "", lastName: "", age: 18, profilePictureURL: "", closeTo: false)
    }
}
