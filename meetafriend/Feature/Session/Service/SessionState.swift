//
//  SessionState.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//

import Combine
import Foundation

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, 
