//
//  RegistrationService.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//
import Combine
import FirebaseDatabase
import Firebase
import Foundation

enum RegistrationKeys: String {
    case firstName
    case lastName
    case age
}

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth()
                    .createUser(withEmail: details.email,
                                password: details.password) { res, error in
                        if let err = error {
                            // if error, push so we can subscribe to it
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                let values = [RegistrationKeys.firstName.rawValue: details.firstName,
                                              RegistrationKeys.lastName.rawValue: details.lastName,
                                              RegistrationKeys.age.rawValue: details.age] as [String: Any]
                                
                                // Update user with these values in firebase
                                Database.database()
                                    .reference()
                                    .child("users")
                                    .child(uid)
                                    .updateChildValues(values) { error, ref in
                                        if let err = error {
                                            // push error
                                            promise(.failure(err))
                                        } else {
                                            // push success which is void
                                            promise(.success(()))
                                        }
                                    }
                            } else {
                                promise(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
                            }
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
