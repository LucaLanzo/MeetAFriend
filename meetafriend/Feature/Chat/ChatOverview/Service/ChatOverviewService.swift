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

public struct RecentMessage: Identifiable {
    public var id: String?
    var chatUser: User
    var messageFromId: String
    var recentMessage: Message
    var fromSelf: Bool
    
    init (_ chatUserId: String, _ chatUser: User, _ messageFromId: String, _ recentMessage: Message, _ fromSelf: Bool) {
        self.id = chatUserId
        self.chatUser = chatUser
        self.messageFromId = messageFromId
        self.recentMessage = recentMessage
        self.fromSelf = fromSelf
    }
}

protocol ChatOverviewService {
    var users: [User] { get }
    var location: Location? { get }
    var recentMessages: [RecentMessage] { get }
}

final class ChatOverviewServiceImpl: ObservableObject, ChatOverviewService {
    @Published var users: [User] = []
    @Published var location: Location? = nil
    @Published var recentMessages: [RecentMessage] = []
    
    private var lid: String = ""
    private var userKeys: [String] = []
    
    private let db = Firestore.firestore()
    private var joinedLocationListener: ListenerRegistration?
    private var joinedLocationRecentMessagesListener: ListenerRegistration?
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
        
        self.joinedLocationRecentMessagesListener = db.collection("locations").document(self.location!.id!).collection("chats").whereField("users", arrayContains: uid).addSnapshotListener { querySnapshot, error in
            guard let chats = querySnapshot else {
                print("ChatOverviewService: Error fetching chats.")
                return
            }
            print("RM: Found \(chats.count) chats.")
            
            for chat in chats.documents {
                chat.reference.collection("messages").order(by: "timestamp", descending: true).addSnapshotListener { querySnapshotMessages, errorMessages in
                    guard let messages = querySnapshotMessages else {
                        print("ChatOverviewService: Error fetching messages in chats.")
                        return
                    }
                    
                    for message in messages.documents {
                        do {
                            let message = try message.data(as: Message.self)
                            
                            
                            let userId: String
                            
                            if message.toId == uid {
                                userId = message.fromId
                            } else {
                                userId = message.toId
                            }
                            
                            let fromSelf = message.fromId == uid
                            
                            self.db.collection("users").document(userId).getDocument(as: User.self) { result in
                                switch result {
                                case .success(let user):
                                    // clear previous recent message
                                    if let recentMessageIndex = self.recentMessages.firstIndex(where: { $0.id == user.id! }) {
                                        self.recentMessages.remove(at: recentMessageIndex)
                                    }
                                    self.recentMessages.insert(RecentMessage(user.id!, user, message.fromId, message, fromSelf), at: 0)
                                    
                                case .failure(let error):
                                    print("ChatOverviewService: Error finding recent message user: \(error)")
                                }
                            }
                        } catch {
                            print("ChatOverviewService: Error decoding firebase response to Message. \(error)")
                        }
                        
                        break
                    }
                }
            }
        }
    }
    
    func loadUsers(uid: String) {
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
    
    func closeListenForUsers() {
        if (self.joinedLocationListener != nil) {
            self.joinedLocationListener!.remove()
        }
        
        if (self.joinedLocationRecentMessagesListener != nil) {
            self.joinedLocationRecentMessagesListener!.remove()
        }
        
        self.users.removeAll()
        self.userKeys.removeAll()
        self.recentMessages.removeAll()
    }
}

