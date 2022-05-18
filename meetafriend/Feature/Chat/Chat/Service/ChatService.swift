//
//  ChatService.swift
//  meetafriend
//
//  Created by Luca on 18.05.22.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift



protocol ChatService {
    var user: User? { get }
    var messages: [Message] { get }
    var message: String { get }
}

final class ChatServiceImpl: ObservableObject, ChatService {
    @Published var user: User? = nil
    @Published var messages: [Message] = []
    @Published var message: String = ""
    
    private let db = Firestore.firestore()
    
    init() {
        listenForUser()
    }
}


private extension ChatServiceImpl {
    func listenForUser() {
        let uid = Auth.auth().currentUser
        if (uid == nil) { return }
        
        var joinedLid = ""
        
        let listener = db.collection("locations").whereField("joinedUsers", arrayContains: uid!.uid).addSnapshotListener() { querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("No joined Location found")
                return
            }
            
            for document in snapshot.documents {
                joinedLid = document.documentID
                break
            }
        }
        
        listener.remove()       
        
    }
    
    func loadUsers(uid: String) {
        
    }
}
