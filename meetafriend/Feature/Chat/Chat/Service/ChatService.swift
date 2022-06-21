//
//  ChatService.swift
//  meetafriend
//
//  Created by Luca on 18.05.22.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift



protocol ChatService {
    var chatUser: User? { get }
    var text: String { get }
    var messages: [Message] { get }
}

final class ChatServiceImpl: ObservableObject, ChatService {
    @Published var chatUser: User? = nil
    @Published var text: String = ""
    @Published var messages: [Message] = []
    
    private var lid: String = ""
    
    private let db = Firestore.firestore()
    
    init() {
        getLocation()
    }
}


private extension ChatServiceImpl {
    func getLocation() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("locations").whereField("joinedUsers", arrayContains: uid).addSnapshotListener() { querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("No joined Location found")
                return
            }
            
            for document in snapshot.documents {
                self.lid = document.documentID
                self.fetchMessages()
                break
            }
        }
    }
}

extension ChatServiceImpl {
    func sendMessage() {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        guard let toId = chatUser?.id else { return }
        
        let text = self.text

        let document = db.collection("locations").document(lid).collection("messages")
            .document(fromId)
            .collection(toId)
            .document()

        let message = ["fromId": fromId, "toId": toId, "text": text, "timestamp": Timestamp()] as [String : Any]
        
        document.setData(message) { error in
            if let error = error {
                print("ChatService \(error)")
                return
            }

            print("Successfully saved current user sending message")
            self.text = ""
        }

        let recipientDocument = db.collection("locations").document(lid).collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientDocument.setData(message) { error in
            if let error = error {
                print(error)
                return
            }

            print("Recipient saved message as well")
        }
    }
    
    func fetchMessages() {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        guard let toId = chatUser?.id else { return }
        
        db.collection("locations").document(lid).collection("messages").document(fromId).collection(toId).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("ChatService couldn't fetchMessages \(error)")
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let data = try change.document.data(as: Message.self)
                            self.messages.append(data)
                        } catch {
                            print(error)
                        }
                    }
                })
            }
    }
}
