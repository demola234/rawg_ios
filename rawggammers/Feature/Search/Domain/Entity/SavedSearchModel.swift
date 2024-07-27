//
//  SavedSearchModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import SwiftData

// MARK: - SavedSearchModel

@Model
final class SavedSearchModel {
    var name: String
    var slug: String
    var playtime: Int
    var released: String
    var backgroundImage: String
    var updated: String
    @Attribute(.unique)
    var id : Int
    var reviewsCount: Int
    var communityRating: Int
    
    init(name: String, slug: String, playtime: Int, released: String, backgroundImage: String, updated: String, id: Int, reviewsCount: Int, communityRating: Int) {
        self.name = name
        self.slug = slug
        self.playtime = playtime
        self.released = released
        self.backgroundImage = backgroundImage
        self.updated = updated
        self.id = id
        self.reviewsCount = reviewsCount
        self.communityRating = communityRating
    }
    
}



