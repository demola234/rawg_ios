//
//  MoviesEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation

// MARK: - MoviesEntity
struct MoviesEntity: Codable {
    let results: [MoviesResult]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

// MARK: - Result
struct MoviesResult: Codable {
    let id: Int?
    let name: String?
    let preview: String?
    let data: DataClass?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case preview
        case data
    }
}
// MARK: - DataClass
struct DataClass: Codable {
    let the480, max: String?
    
    enum CodingKeys: String, CodingKey {
        case the480
        case max
    }
}
