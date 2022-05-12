//
//  LocationDetails.swift
//  meetafriend
//
//  Created by Luca on 11.05.22.
//

import Foundation
import FirebaseFirestore

public class LocationDetails: Identifiable {
    public var id: String
    var name: String
    
    var country: String
    var city: String
    var zipCode: Int
    var street: String
    var houseNumber: Int
    
    // var coordinates: [String: Any]

    var joinedUsers: [String]
    
    init?(lid: String?, data: [String: Any]) {
        guard let id = lid else {
            print("No lid detected, exiting...")
            return nil
        }
        
        guard let name = data["name"] as? String,
        let country = data["country"] as? String,
        let city = data["city"] as? String,
        let zipCode = data["zipCode"] as? Int,
        let street = data["street"] as? String,
        let houseNumber = data["houseNumber"] as? Int,
        // let coordinates = data["coordinates"] as? [String: Any],
        let joinedUsers = data["joinedUsers"] as? [String]
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.country = country
        self.city = city
        self.zipCode = zipCode
        self.street = street
        self.houseNumber = houseNumber
        // self.coordinates = coordinates
        self.joinedUsers = joinedUsers
    }
}

