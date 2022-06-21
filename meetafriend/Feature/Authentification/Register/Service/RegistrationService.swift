//
//  RegistrationService.swift
//  meetafriend
//
//  Created by Luca on 25.03.22.
//
import Combine
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage
import Firebase
import SwiftUI
import Foundation

enum RegistrationKeys: String {
    case firstName
    case lastName
    case age
    case profilePictureURL
    case chatWith
}

protocol RegistrationService {
    func register(with details: RegistrationDetails, with image: UIImage?) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    func register(with details: RegistrationDetails, with image: UIImage?) -> AnyPublisher<Void, Error> {
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
                                // Persist image to storage
                                let ref = self.storage.reference(withPath: uid)
                                
                                guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
                                var profilePictureURL = ""
                                
                                ref.putData(imageData, metadata: nil) { metadata, err in
                                    if let err = err {
                                        print("Failed to push image to Storage: \(err)")
                                        return
                                    }

                                    ref.downloadURL { url, err in
                                        if err != nil {
                                            print("Could not download image data")
                                            return
                                        }
                                        
                                        if url?.absoluteString != nil {
                                            print("Successfully saved image under \(url!.absoluteString)")
                                            profilePictureURL = url!.absoluteString
                                        }
                                    }
                                }
                                
                                // put user data into firestore
                                self.db.collection("users").document(uid).setData([
                                    RegistrationKeys.firstName.rawValue: details.firstName,
                                    RegistrationKeys.lastName.rawValue: details.lastName,
                                    RegistrationKeys.age.rawValue: details.age,
                                    RegistrationKeys.profilePictureURL.rawValue: profilePictureURL
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
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
