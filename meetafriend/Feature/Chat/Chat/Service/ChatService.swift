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
    var chatUser: User? { get }
    var text: String { get }
    var messages: [Message] { get }
}

final class ChatServiceImpl: ObservableObject, ChatService {
    @Published var chatUser: User? = nil
    @Published var text: String = ""
    @Published var messages: [Message] = []
    
    private var lid: String = ""
    private var initial: Bool = true
    private var locationChange: Bool = false
    private var oldUserId: String = ""
    private var joinedMessageListener: ListenerRegistration?
    
    private let db = Firestore.firestore()
    
    init() {
        getLocation()
    }
}


extension ChatServiceImpl {
    func getLocation() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("locations").whereField("joinedUsers", arrayContains: uid).addSnapshotListener() { querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("No joined Location found")
                return
            }
            
            for document in snapshot.documents {
                let lid = document.documentID
                
                if (self.lid == "") {
                    self.lid = lid
                    
                    print("Location initial")
                    
                    self.initial = true
                } else if (self.lid != "" && self.lid != lid) {
                    self.lid = lid
                    
                    print("Location change")
                    
                    self.locationChange = true
                }
                
                break
            }
        }
    }
    
    func sendMessage() {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }

        var chatId = ""
        let chatSearch = db.collection("locations").document(lid).collection("chats").whereField("users", arrayContainsAny: ["\(fromId)\(toId)", "\(toId)\(fromId)"])
        
        chatSearch.getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("ChatService: Error getting chat")
                return
            }
            
            if snapshot.documents.count == 0 {
                let newChat = self.db.collection("locations").document(self.lid).collection("chats").document()
                
                let data = ["users": ["\(fromId)\(toId)"]] as [String : Any]
                
                newChat.setData(data) { error in
                    if let error = error {
                        print("ChatService: error setting new Chat \(error)")
                        return
                    }
                    
                    chatId = newChat.documentID
                    self.sendMessageData(chatId: chatId)
                }
                
                chatId = newChat.documentID
            } else {
                for document in snapshot.documents {
                    chatId = document.documentID
                    
                    self.sendMessageData(chatId: chatId)
                    return
                }
            }
        }
    }
    
    func sendMessageData(chatId: String) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }
        let text = self.text
        
        let newMessage = db.collection("locations").document(lid).collection("chats").document(chatId).collection("messages").document()

        let data = ["fromId": fromId, "toId": toId, "text": text, "timestamp": Timestamp()] as [String : Any]
        
        newMessage.setData(data) { error in
            if let error = error {
                print("ChatService: Error sending new message \(error)")
                return
            }
            
            print("ChatService: Successfully saved new message")
            
            self.text = ""
        }
    }

    
    func checkForNewChat(newUserChat: User) {
        if (initial) {
            print("Check initial - fetch")
            self.initial = false
            
            self.fetchMessages()
            
            return
        }
        
        if (locationChange) {
            print("Check change - close - fetch")
            self.locationChange = false
            
            self.closeListenForMessages()
            self.fetchMessages()
            
            return
        }
        
        if (oldUserId != newUserChat.id!) {
            print("Check user change - close - fetch")
            oldUserId = newUserChat.id!
            
            self.closeListenForMessages()
            self.fetchMessages()
            
            return
        }
        
        print("Check no change")
    }
    
}

private extension ChatServiceImpl {
    
    func fetchMessages() {        
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }
        
        var chatId = ""
        
        let chatSearch = db.collection("locations").document(lid).collection("chats").whereField("users", arrayContainsAny: ["\(fromId)\(toId)", "\(toId)\(fromId)"])
            
        chatSearch.getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("ChatService: Error getting chat")
                return
            }
            
            if snapshot.documents.count == 0 {
                let newChat = self.db.collection("locations").document(self.lid).collection("chats").document()
                
                let data = ["users": ["\(fromId)\(toId)"]] as [String : Any]
                
                newChat.setData(data) { error in
                    if let error = error {
                        print("ChatService: error setting new Chat \(error)")
                        return
                    }
                    
                    self.fetchMessages(chatId: chatId)
                }
                
                chatId = newChat.documentID
            } else {
                for document in snapshot.documents {
                    chatId = document.documentID
                    
                    self.fetchMessages(chatId: chatId)
                    
                    return
                }
            }
        }
    }
    
    func fetchMessages(chatId: String) {
        self.joinedMessageListener = db.collection("locations").document(lid).collection("chats").document(chatId).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
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
                
                if change.type == .removed {
                    if let message = self.messages.firstIndex(where: { $0.id ==
                        change.document.documentID}) {
                        self.messages.remove(at: message)
                    }
                }
            })
        }
    }
    
    
    func closeListenForMessages() {
        if (self.joinedMessageListener != nil) {
            self.joinedMessageListener!.remove()
        }
        
        self.messages.removeAll()
    }
    
}
