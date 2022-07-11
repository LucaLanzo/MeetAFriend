//
//  LocationService.swift
//  meetafriend
//
//  Created by Luca on 11.05.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase


enum LocationState {
    case joined
    case notJoined
}

protocol LocationService {
    var locations: [Location] { get }
    var state: LocationState { get }
    var joinedLocation: String? { get }
    var listenStarted: Bool { get }
    
    func joinLocation(lid: String)
}

final class LocationServiceImpl: ObservableObject, LocationService {
    @Published var locations: [Location] = []
    @Published var state: LocationState = .notJoined
    @Published var joinedLocation: String?
    @Published var listenStarted: Bool = false
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func joinLocation(lid: String) {
        joinLocation(with: lid)
    }
}



private extension LocationServiceImpl {
    // update data
    func handleRefresh() {
        listener = db.collection("locations").addSnapshotListener { querySnapshot, error in
            // if it is the first time the app is started, check if still joined
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
                print("Locationservice check for join!")
                self.checkIfJoined()
                checkForJoin = false
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
                    self.joinedLocation = location.id!
                    return
                }
            }
        }
        
        self.state = .notJoined
        self.joinedLocation = nil
    }
    
    
    func joinLocation(with lid: String) {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        self.joinedLocation = lid
        
        let locationRef = db.collection("locations").document(lid)

        // Add a new user id to the "joinedUsers" array field.
        locationRef.updateData([
            "joinedUsers": FieldValue.arrayUnion([uid!.uid])
        ])
        
        if (self.state != .joined) {
            self.state = .joined
        }
    }
}

extension LocationServiceImpl {
    
    // initially load data
    func loadLocations() {
        self.handleRefresh()
        self.checkIfJoined()
        self.listenStarted = true
    }
    
    func stopLoadingLocations() {
        listener?.remove()
        
        self.listenStarted = false
        self.locations.removeAll()
        self.state = .notJoined
    }
    
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
        self.joinedLocation = nil
    }
    
}
