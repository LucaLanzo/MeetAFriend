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
import Combine
import FirebaseCore

enum LocationState {
    case joined
    case notJoined
}

protocol LocationService {
    var locations: [Location] { get }
    var state: LocationState { get }
    var joinedLocation: Location? { get }
    
    func joinLocation(lid: String)
}

final class LocationServiceImpl: ObservableObject, LocationService {
    @Published var locations: [Location] = []
    @Published var state: LocationState = .notJoined
    @Published var joinedLocation: Location?
    
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
                    let changedLocation = Location(lid: diff.document.documentID, data: diff.document.data())
                    
                    if let location = self.locations.firstIndex(where: { $0.id ==
                        diff.document.documentID}) { self.locations[location] = changedLocation!
                    }
                case(.added):
                    let newLocation = Location(lid: diff.document.documentID, data: diff.document.data())
                    
                    self.locations.append(newLocation!)
                case .removed:
                    print("\(diff.document.data()["name"] ?? "Nothing") has been deleted.")
                }
            }
        }
    }
    
    
    func joinLocation(with lid: String) {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        let locationRef = db.collection("locations").document(lid)

        // Add a new user id to the "joinedUsers" array field.
        locationRef.updateData([
            "joinedUsers": FieldValue.arrayUnion([uid!.uid])
        ])
        
        updateJoinedLocation(with: lid)
        
        self.state = .joined
    }
    
    
    func updateJoinedLocation(with lid: String) {
        db.collection("locations").document(lid).addSnapshotListener {
            documentSnapshot, error in
            guard let location = documentSnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            guard let data = location.data() else {
                print("Document data was empty.")
                return
            }
            
            self.joinedLocation = Location(lid: location.documentID, data: data)
        }
    }
}

extension LocationServiceImpl {
    func leaveLocation() {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        if self.joinedLocation?.id == "" { return }
        let locationRef = db.collection("locations").document(self.joinedLocation!.id)
        
        // Add a new user id to the "joinedUsers" array field.
        locationRef.updateData([
            "joinedUsers": FieldValue.arrayRemove([uid!.uid])
        ])
        
        self.joinedLocation = nil
        self.state = .notJoined
    }
}
