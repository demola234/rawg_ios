//
//  UsersDataEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//
import Foundation

struct UsersDataEntity: Codable {
    var uid: String
    var email: String
    var username: String
    var profileImageURL: String
    var registrationType: String
    var isLoggedIn: Bool
    var provider: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case username
        case profileImageURL
        case registrationType
        case provider
        case isLoggedIn
        case createdAt
        case updatedAt
    }
    
    init(uid: String = "",
         email: String = "",
         username: String = "",
         profileImageURL: String = "",
         registrationType: String = "",
         isLoggedIn: Bool = false,
         provider: String = "",
         createdAt: String = "",
         updatedAt: String = "") {
        self.uid = uid
        self.email = email
        self.username = username
        self.profileImageURL = profileImageURL
        self.registrationType = registrationType
        self.isLoggedIn = isLoggedIn
        self.provider = provider
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        email = try container.decode(String.self, forKey: .email)
        username = try container.decode(String.self, forKey: .username)
        profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
        registrationType = try container.decode(String.self, forKey: .registrationType)
        provider = try container.decode(String.self, forKey: .provider)
        isLoggedIn = try container.decode(Bool.self, forKey: .isLoggedIn)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
}
