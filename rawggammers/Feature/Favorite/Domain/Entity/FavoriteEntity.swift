//
//  FavoriteEntity.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation

struct FavoriteEntity: Identifiable {
        var id: UUID = .init()
        var slug, name, released: String?
        var backgroundImage: String?
        var rating: Double?
        var ratingTop: Int?
        var playtime, suggestionsCount: Int?
        var updated: String?
        var reviewsCount: Int?
}
