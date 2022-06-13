//
//  ChatOverviewService.swift
//  meetafriend
//
//  Created by Luca on 16.05.22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

enum ChatState {
    case joined
    case notJoined
}

protocol ChatOverviewService {
    var users: [User] { get }
    var state: ChatState { get }
}

final class ChatOverviewServiceImpl: ObservableObject, ChatOverviewService {
    @Published var users: [User] = []
    @Published var state: ChatState = .notJoined
    
    private var userKeys: [String] = []
    
    private let db = Firestore.firestore()
    
    init() {
        listenForUsers()
    }
}


private extension ChatOverviewServiceImpl {
    func listenForUsers() {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        
        db.collection("locations").whereField("joinedUsers", arrayContains: uid!.uid).addSnapshotListener() { querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("No joined Location found")
                return
            }
            
            for document in snapshot.documents {
                do {
                    self.userKeys = try document.data(as: Location.self).joinedUsers
                    
                    self.loadUsers(uid: uid!.uid)
                    
                    break
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func loadUsers(uid: String) {
        // TODO: Extremely inefficient! MVP working, but needs refactoring badly
        self.users = []
        
        for userKey in userKeys {
            if userKey == uid { continue }
            
            db.collection("users").document(userKey).getDocument(as: User.self) { result in
                
                switch result {
                case .success(let user):
                    self.users.append(user)
                case .failure(let error):
                    print("Error decoding user: \(error)")
                }
                
            }
        }
    }
    
    func startChat(withUser: String) {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        var localUser: User? = nil
        
        db.collection("users").document(uid!.uid).getDocument(as: User.self) { result in
            
            switch result {
            case .success(let user):
                localUser = user
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
            
        }
        
        localUser?.chatWith = withUser
        
        do {
            try db.collection("users").document(uid!.uid).setData(from: localUser)
        } catch let error {
            print("Error updating starting Chat with user \(error)")
        }
        
        self.state = .joined
        
    }
}
