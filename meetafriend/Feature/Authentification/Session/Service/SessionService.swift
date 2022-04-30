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
import FirebaseStorage

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
        Database.database(url: "https://meet-a-friend-1b475-default-rtdb.europe-west1.firebasedatabase.app")
            .reference()
            .child("users")
            .child(uid)
            .observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? NSDictionary,
                      let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                      let lastName = value[RegistrationKeys.lastName.rawValue] as? String,
                      let age = value[RegistrationKeys.age.rawValue] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.userDetails = SessionUserDetails(firstName: firstName,
                                                          lastName: lastName,
                                                          age: age)
                }
            }
    }
}
