//
//  SearchEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation

// MARK: - SearchEntity
struct SearchEntity: Codable {
    let count: Int?
    let results: [SearchResult]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}

// MARK: - Result
struct SearchResult: Codable {
    let slug, name: String?
    let playtime: Int?
    let released: String?
    let backgroundImage: String?
    let updated: String?
    let stores: [SearchStore]?
    let id: Int?
    let score: String?
    let reviewsCount, communityRating: Int?
    
    enum CodingKeys: String, CodingKey {
        case slug, name, playtime, released
        case backgroundImage = "background_image"
        case updated, stores, id, score
        case reviewsCount = "reviews_count"
        case communityRating = "community_rating"
    }
}

// MARK: - Store
struct SearchStore: Codable {
    let store: RelatedTag?
    
    enum CodingKeys: String, CodingKey {
        case store
    }
}

struct RelatedTag: Codable {
    let id: Int?
    let slug, name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name
    }
}

// MARK: - Tag
struct Tag: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

