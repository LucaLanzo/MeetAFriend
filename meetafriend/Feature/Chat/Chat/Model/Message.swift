//
//  Message.swift
//  meetafriend
//
//  Created by Luca on 18.05.22.
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import Foundation

public struct Message: Codable, Identifiable {
    @DocumentID public var id: String?
    
    public var fromId: String
    public var toId: String
    public var text: String
    public var timestamp: Timestamp
    
    init(fromId: String, toId: String, text: String) {
        self.fromId = fromId
        self.toId = toId
        self.text = text
        self.timestamp = Timestamp()
    }
}
