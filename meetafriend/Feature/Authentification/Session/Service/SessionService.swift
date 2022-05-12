//
//  SessionState.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import Combine
import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private let db = Firestore.firestore()
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFireBaseAuthHandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}

private extension SessionServiceImpl {
    // check if logged in or out
    func setupFireBaseAuthHandler() {
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] res, user in
                // if user is nil, then logged out
                guard let self = self else { return }
                // if not nil, logged in
                self.state = user == nil ? .loggedOut : .loggedIn
                if let uid = user?.uid {
                    self.handleRefresh(with: uid)
                }
            }
    }
    
    // update user data
    func handleRefresh(with uid: String) {
        // TODO: DONT LISTEN JUST GET
        db.collection("users").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                let value = data as NSDictionary
                let firstName = value[RegistrationKeys.firstName.rawValue] as? String
                let lastName = value[RegistrationKeys.lastName.rawValue] as? String
                let age = value[RegistrationKeys.age.rawValue] as? Int
                
                DispatchQueue.main.async {
                    self.userDetails = SessionUserDetails(firstName: firstName ?? "N/A",
                                                          lastName: lastName ?? "N/A",
                                                          age: age ?? 18)
                }
            }
    }
}
