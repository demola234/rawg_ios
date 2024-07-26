//
//  PlatformsEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import SwiftUI

// MARK: - PlatformsEntity
struct PlatformsEntity: Codable {
    let count: Int?
    let next, previous: String?
    let results: [PlatformResult]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}

// MARK: - Result
struct PlatformResult: Codable {
    let id: Int?
    let name, slug: String?
    let platforms: [PlatformValue]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case platforms
    }
}

// MARK: - PlatformValue
struct PlatformValue: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case image
    }
}
