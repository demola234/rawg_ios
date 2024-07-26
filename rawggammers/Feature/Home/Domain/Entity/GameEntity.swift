//
//  GameEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//
// GamesEntity.swift

import Foundation

// MARK: - GamesEntity
struct GamesEntity: Codable {
    let count: Int?
    let next, previous: String?
    let results: [ResultData]?
    let gamesCount, reviewsCount, recommendationsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
        case gamesCount = "games_count"
        case reviewsCount = "reviews_count"
        case recommendationsCount = "recommendations_count"
    }
}

// MARK: - Result
struct ResultData: Codable {
    let id: Int?
    let slug, name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let ratingsCount, reviewsTextCount, added: Int?
    let playtime, suggestionsCount: Int?
    let updated: String?
    let reviewsCount: Int?
    let platforms: [PlatformElement]?
    let genres: [Genre]?
    let stores: [Store]?
    let tags: [Genre]?
    let shortScreenshots: [ShortScreenshot]?
    let communityRating: Int?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case reviewsCount = "reviews_count"
        case platforms, genres, stores, tags
        case shortScreenshots = "short_screenshots"
        case communityRating = "community_rating"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain, language
    }
}


// MARK: - PlatformElement
struct PlatformElement: Codable {
    let platform: PlatformPlatform?
    let releasedAt: String?


    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
    }
}


// MARK: - PlatformPlatform
struct PlatformPlatform : Codable{
    let id: Int?
    let name: String?
    let slug: String?
    let image: String?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case imageBackground = "image_background"
    }
}



// MARK: - Rating
struct Rating: Codable {
    let id: Int?
    let title: String?
    let count: Int?
    let percent: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, count, percent
    }
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Codable {
    let id: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, image
    }
}


// MARK: - Store
struct Store: Codable {
    let id: Int?
    let store: Genre?

    enum CodingKeys: String, CodingKey {
        case id, store
    }
}
