//
//  Message.swift
//  meetafriend
//
//  Created by Luca on 18.05.22.
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import Foundation

public class Message: Codable, Identifiable {
    @DocumentID public var id: String?
    
    public var from: String
    public var to: String
    public var message: String
    public var time: Timestamp
}
