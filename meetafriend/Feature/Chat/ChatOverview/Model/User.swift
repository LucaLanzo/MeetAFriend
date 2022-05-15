//
//  User.swift
//  meetafriend
//
//  Created by Luca on 16.05.22.
//

import Foundation
import FirebaseFirestoreSwift

public class User: Codable, Identifiable {
    @DocumentID public var id: String?
    
    public var firstName: String
    public var lastName: String
    public var age: Int
}
