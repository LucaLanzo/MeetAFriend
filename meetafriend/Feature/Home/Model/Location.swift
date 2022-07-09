//
//  LocationDetails.swift
//  meetafriend
//
//  Created by Luca on 11.05.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Location: Codable, Identifiable {
    @DocumentID public var id: String?
    
    public var name: String
    public var subDescription: String
    
    public var country: String
    public var city: String
    public var zipCode: Int
    public var street: String
    public var houseNumber: Int
    
    public var coordinates: GeoPoint

    public var joinedUsers: [String]
    
    public var locationPictureURL: String
}

