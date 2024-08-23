//
//  UserEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import FirebaseFirestore

class User: Codable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var authType: String
    var photoUrl: String
    var dateCreated: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case authType
        case photoUrl
        case dateCreated
    }
    
    init(id: String, email: String, name: String, authType: String, photoUrl: String, dateCreated: Timestamp) {
        self.id = id
        self.email = email
        self.name = name
        self.authType = authType
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
    }
}
