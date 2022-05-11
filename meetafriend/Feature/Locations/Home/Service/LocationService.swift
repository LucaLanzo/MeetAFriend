//
//  LocationService.swift
//  meetafriend
//
//  Created by Luca on 11.05.22.
//

import Combine
import FirebaseFirestore
import FirebaseCore
import Firebase
import Foundation
import Contacts

enum LocationKeys: String {
    case city
    case coordinates
    case country
    case houseNumber
    case joinedUsers
    case name
    case street
    case zipCode
}

protocol LocationService {
    var locationDetails: [LocationDetails]? { get }
    
    func joinLocation(lid: String)
}

final class LocationServiceImpl: ObservableObject, LocationService {
    @Published var locationDetails: [LocationDetails]?
    
    private let db = Firestore.firestore()
    
    init() {
        locationDetails = [LocationDetails]()
        loadLocations()
    }
    
    func joinLocation(lid: String) {
        joinLocation(with: lid)
    }
}

private extension LocationServiceImpl {
    // initially load data
    func loadLocations() {
        db.collection("locations").getDocuments() { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            DispatchQueue.main.async {
                self.locationDetails = self.updateVariables(with: documents)
            }
            
        }
        
        self.handleRefresh()
    }
    
    // update data
    func handleRefresh() {
        db.collection("locations").addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            let locations = documents.map { $0["name"]! }
            print("Current updated locations: \(locations)")
        }
    }
    
    // update variables
    func updateVariables(with documents: [QueryDocumentSnapshot]) {
        let newLocationDetails = [LocationDetails]()
        
        for (index, location) in documents.enumerated() {
            let name = location[LocationKeys.name.rawValue] as? String
            let country = location[LocationKeys.country.rawValue] as? String
            let city = location[LocationKeys.city.rawValue] as? String
            let zipCode = location[LocationKeys.zipCode.rawValue] as? Int
            let street = location[LocationKeys.street.rawValue] as? String
            let houseNumber = location[LocationKeys.houseNumber.rawValue] as? Int
            let coordinates = location[LocationKeys.coordinates.rawValue] as? [String]
            let joinedUsers = location[LocationKeys.joinedUsers.rawValue] as? [String]
            
            
            newLocationDetails.append(LocationDetails(name: name, country: country, city: city, zipCode: zipCode, street: street, houseNumber: houseNumber, coordinates: coordinates, joinedUsers: joinedUsers))
        }
        
        return newLocationDetails
    }
    
    func joinLocation(with lid: String) {
        print("Joined location")
    }
}
