//
//  GameDetailsEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

// GameDetailsEntity.swift

import Foundation

// MARK: - GameDetailsEntity
struct GameDetailsEntity {
    let results: [GamesDetailsResult]?
}

// MARK: - Result
struct GamesDetailsResult {
    let id: Int?
    let slug, name, released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let ratingsCount, reviewsTextCount, added: Int?
    let addedByStatus: AddedByStatus?
    let metacritic: Int?
    let playtime, suggestionsCount: Int?
    let updated: String?
    let userGame: NSNull?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: String?
    let platforms: [PlatformElement]?
    let parentPlatforms: [ParentPlatform]?
    let genres: [Genre]?
    let stores: [Store]?
    let clip: NSNull?
    let tags: [Genre]?
    let esrbRating: EsrbRating?
    let shortScreenshots: [ShortScreenshot]?
}

// AddedByStatus.swift

import Foundation

// MARK: - AddedByStatus
struct AddedByStatus {
    let yet, owned, beaten, toplay: Int?
    let dropped, playing: Int?
}

// EsrbRating.swift

import Foundation

// MARK: - EsrbRating
struct EsrbRating {
    let id: Int?
    let name, slug: String?
}

// Genre.swift

import Foundation

// MARK: - Genre
struct Genre {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?
    let language: Language?
}

// Language.swift

import Foundation

enum Language: String {
    case eng
}

// ParentPlatform.swift

import Foundation

// MARK: - ParentPlatform
struct ParentPlatform {
    let platform: EsrbRating?
}

// PlatformElement.swift

import Foundation

// MARK: - PlatformElement
struct PlatformElement {
    let platform: PlatformPlatform?
    let releasedAt: String?
    let requirementsEn, requirementsRu: Requirements?
}

// PlatformPlatform.swift

import Foundation

// MARK: - PlatformPlatform
struct PlatformPlatform {
    let id: Int?
    let name, slug: String?
    let image, yearEnd: NSNull?
    let yearStart: Int?
    let gamesCount: Int?
    let imageBackground: String?
}

// Requirements.swift

import Foundation

// MARK: - Requirements
struct Requirements {
    let minimum, recommended: String?
}

// Rating.swift

import Foundation

// MARK: - Rating
struct Rating {
    let id: Int?
    let title: Title?
    let count: Int?
    let percent: Double?
}

// Title.swift

import Foundation

enum Title: String {
    case exceptional
    case meh
    case recommended
    case skip
}

// ShortScreenshot.swift

import Foundation

// MARK: - ShortScreenshot
struct ShortScreenshot {
    let id: Int?
    let image: String?
}

// Store.swift

import Foundation

// MARK: - Store
struct Store {
    let id: Int?
    let store: Genre?
}
