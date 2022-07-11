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
                                
                                // put user data into firestore
                                self.db.collection("users").document(uid).setData([
                                    RegistrationKeys.firstName.rawValue: details.firstName,
                                    RegistrationKeys.lastName.rawValue: details.lastName,
                                    RegistrationKeys.age.rawValue: details.age,
                                    RegistrationKeys.profilePictureURL.rawValue: ""
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                        
                                        // Persist image to storage
                                        if (image != nil) {
                                            let data = image!.jpegData(compressionQuality: 0.5)!
                                            // set upload path
                                            let filePath = uid
                                            let metaData = StorageMetadata()
                                            metaData.contentType = "image/jpg"
                                            
                                            self.storage.reference().child(filePath).putData(data, metadata: metaData) { metaData, error in
                                                if let error = error {
                                                    print("Registration Service error while uploading picture \(error.localizedDescription)")
                                                    return
                                                } else {
                                                    
                                                    self.storage.reference().child(filePath).downloadURL { url, error in
                                                        if let error = error {
                                                            print("Registration Service error while downloading picture URL \(error.localizedDescription)")
                                                            return
                                                        } else {
                                                        
                                                            if let urlString = url?.absoluteString {
                                                                print("RegistrationService image url \(urlString)")
                                                                
                                                                self.db.collection("users").document(uid).updateData([
                                                                    "profilePictureURL": urlString
                                                                ])
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
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
    
    func updateProfilePicture(uid: String) {
        
        
        
    }
}
