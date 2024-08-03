//
//  GameScreenShotsEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 03/08/2024.
//

import Foundation


// MARK: - GameScreenShotsEntity
struct GameScreenShotsEntity: Codable {
    let count: Int?
    let results: [ScreenShotResult]?
    
    enum CodingKeys: String, CodingKey {
        case count, results
    }
}

// MARK: - Result
struct ScreenShotResult: Codable {
    let id: Int?
    let image: String?
    let width, height: Int?
    let isDeleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, image, width, height
        case isDeleted = "is_deleted"
    }
}
