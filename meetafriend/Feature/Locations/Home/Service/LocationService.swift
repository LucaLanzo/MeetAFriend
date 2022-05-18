//
//  LocationService.swift
//  meetafriend
//
//  Created by Luca on 11.05.22.
//


import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift


enum LocationState {
    case joined
    case notJoined
}

protocol LocationService {
    var locations: [Location] { get }
    var state: LocationState { get }
    // var joinedLocation: Location? { get }
    
    func joinLocation(lid: String)
}

final class LocationServiceImpl: ObservableObject, LocationService {
    @Published var locations: [Location] = []
    @Published var state: LocationState = .notJoined
    
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
        self.handleRefresh()
        self.checkIfJoined()
    }
    
    // update data
    func handleRefresh() {
        // TODO: REMOVE LISTENER ONCE FINISHED
        db.collection("locations").addSnapshotListener { querySnapshot, error in
            // if it is the first time the app is started, check if still joined in location
            var checkForJoin: Bool = false
            self.locations.count == 0 ? (checkForJoin = true) : (checkForJoin = false)
            
            querySnapshot?.documentChanges.forEach{ change in
                switch(change.type) {
                case .modified:
                    do {
                        let changedLocation = try change.document.data(as: Location.self)
                        
                        if let location = self.locations.firstIndex(where: { $0.id ==
                            change.document.documentID}) { self.locations[location] = changedLocation
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                case .added:
                    do {
                        let newLocation = try change.document.data(as: Location.self)
                        
                        self.locations.append(newLocation)
                        
                    } catch {
                        print(error)
                    }
                
                case .removed:
                    print("\(change.document.data()["name"] ?? "Nothing") has been deleted.")
                }
            }
            
            if checkForJoin {
                self.checkIfJoined()
            }
        }
    }
    
    
    func checkIfJoined() {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        for location in locations {
            for user in location.joinedUsers {
                if user == uid!.uid {
                    self.state = .joined
                    return
                }
            }
        }
        
        self.state = .notJoined
    }
    
    
    func joinLocation(with lid: String) {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        let locationRef = db.collection("locations").document(lid)

        // Add a new user id to the "joinedUsers" array field.
        locationRef.updateData([
            "joinedUsers": FieldValue.arrayUnion([uid!.uid])
        ])
        
        // updateJoinedLocation(with: lid)
        
        self.state = .joined
    }
}

extension LocationServiceImpl {
    
    func leaveLocation() {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        var lid = ""
        
        for location in locations {
            for user in location.joinedUsers {
                if user == uid!.uid {
                    lid = location.id!
                    break
                }
            }
        }
                                                
        let locationRef = db.collection("locations").document(lid)
        
        // Add a new user id to the "joinedUsers" array field.
        locationRef.updateData([
            "joinedUsers": FieldValue.arrayRemove([uid!.uid])
        ])
        
        self.state = .notJoined
    }
    
}
