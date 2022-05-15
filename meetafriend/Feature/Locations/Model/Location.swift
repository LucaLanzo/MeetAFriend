//
//  LocationDetails.swift
//  meetafriend
//
//  Created by Luca on 11.05.22.
//

import Foundation
import FirebaseFirestoreSwift

public class Location: Codable, Identifiable {
    @DocumentID public var id: String?
    public var name: String
    
    public var country: String
    public var city: String
    public var zipCode: Int
    public var street: String
    public var houseNumber: Int
    
    // public var coordinates: [String]

    public var joinedUsers: [String]
}

