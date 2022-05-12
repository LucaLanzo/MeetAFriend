//
//  LocationService.swift
//  meetafriend
//
//  Created by Luca on 11.05.22.
//


import Foundation
import Contacts
import FirebaseFirestore
import Firebase
import FirebaseAuth

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
    var locationDetails: [LocationDetails] { get }
    
    func joinLocation(lid: String)
}

final class LocationServiceImpl: ObservableObject, LocationService {
    @Published var locationDetails: [LocationDetails] = []
    
    private let db = Firestore.firestore()
    
    init() {
        loadLocations()
    }
    
    func joinLocation(lid: String) {
        joinLocation(with: lid)
    }
}

private extension LocationServiceImpl {
    // initially load data
    func loadLocations() {
        DispatchQueue.main.async {
            self.handleRefresh()
        }
        
        /*
        db.collection("locations").getDocuments() { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            
            DispatchQueue.main.async {
                for location in documents {
                    let newLocation = LocationDetails(lid: location.documentID, data: location.data())
                    // location can't be empty, because a QueryDocumentSnapshot will always return something
                    self.locationDetails.append(newLocation!)
                    
                    // enable automatic location refresh
                    self.handleRefresh()
                }
            }
        }
        */
    }
    
    // update data
    func handleRefresh() {
        // TODO: REMOVE LISTENER ONCE FINISHED
        db.collection("locations").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                switch(diff.type) {
                case(.modified):
                    let changedLocation = LocationDetails(lid: diff.document.documentID, data: diff.document.data())
                    
                    if let row = self.locationDetails.firstIndex(where: { $0.id ==
                        diff.document.documentID}) { self.locationDetails[row] = changedLocation!
                    }
                case(.added):
                    let newLocation = LocationDetails(lid: diff.document.documentID, data: diff.document.data())
                    
                    self.locationDetails.append(newLocation!)
                case .removed:
                    print("\(diff.document.data()["name"] ?? "Nothing") has been deleted.")
                }
            }
            // let locations = documents.map { $0["name"]! }
            // print("Current updated locations: \(locations)")
            
        }
    }
    
    
    func joinLocation(with lid: String) {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        print("User with id \(uid!.uid) joined location with id \(lid)")
    }
}
