//
//  ChatOverviewService.swift
//  meetafriend
//
//  Created by Luca on 16.05.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase


protocol ChatOverviewService {
    var users: [User] { get }
    var location: Location? { get }
}

final class ChatOverviewServiceImpl: ObservableObject, ChatOverviewService {
    @Published var users: [User] = []
    @Published var location: Location? = nil
    @Published var messages: [(String, Message)] = []
    
    private var lid: String = ""
    private var userKeys: [String] = []
    
    private let db = Firestore.firestore()
    private var joinedLocationListener: ListenerRegistration?
    private var recentMessagesListener: ListenerRegistration?
}


extension ChatOverviewServiceImpl {
    
    func getJoinedLocation() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("locations").whereField("joinedUsers", arrayContains: uid).getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("ChatOverviewService: No joined Location found.")
                return
            }
        
            for document in snapshot.documents {
                do {
                    let location = try document.data(as: Location.self)
                    
                    if (self.location == nil) {
                        self.location = location
                        
                        print("ChatOverviewService: no previous location. listening...")
                        
                        self.listenForUsers()
                    } else if (self.location != nil && self.location!.id! != location.id!) {
                        self.location = location
                        self.closeListenForUsers()
                        
                        print("ChatOverviewService: different location. deleting and listening again ...")
                        
                        self.listenForUsers()
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
    }
}


private extension ChatOverviewServiceImpl {
    
    func listenForUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.joinedLocationListener = db.collection("locations").document(self.location!.id!).addSnapshotListener() { documentSnapshot, err in
            guard let document = documentSnapshot else {
                print("ChatOverviewService: No joined Location found.")
                return
            }
            
            do {
                self.userKeys = try document.data(as: Location.self).joinedUsers
                
                self.loadUsers(uid: uid)
            } catch {
                print(error)
            }
        }
    }
    
    func closeListenForUsers() {
        if (self.joinedLocationListener != nil) {
            self.joinedLocationListener!.remove()
        }
        
        self.users.removeAll()
        self.userKeys.removeAll()
    }
    
    func loadUsers(uid: String) {
        self.users = []
        
        for userKey in userKeys {
            if userKey == uid { continue }
        
            db.collection("users").document(userKey).getDocument(as: User.self) { result in
                
                switch result {
                case .success(let user):
                    print("ChatOverviewService: found user \(user.firstName)")
                    self.users.append(user)
                case .failure(let error):
                    print("Error decoding user: \(error)")
                }
                
            }
        }
    }
}

