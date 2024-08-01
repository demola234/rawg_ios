// DeveloperPreview.swift
// rawggammers
//
// Created by Ademola Kolawole on 26/07/2024.

import Foundation
import SwiftUI


extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {}
    
    let homeViewModel = HomeViewModel()
    
    let gamesData = GamesEntity(
        count: 402,
        next: "https://api.rawg.io/api/games/lists/main?discover=true&filter=true&key=8a275dde2a4f416e8931d049b981d6c4&ordering=-relevance&page=2",
        previous: nil,
        results: [
            ResultData(
                id: 303576,
                slug: "vampire-the-masquerade-bloodlines-2",
                name: "Vampire: The Masquerade - Bloodlines 2",
                released: "2024-11-30",
                backgroundImage: "https://media.rawg.io/media/games/fb5/fb5e0fdb1f6bb0e8b5da5d08bb83a5fc.jpg",
                rating: 3.91,
                ratingTop: 5,
                ratings: [
                    Rating(id: 5, title: "exceptional", count: 116, percent: 45.85),
                    Rating(id: 4, title: "recommended", count: 74, percent: 29.25),
                    Rating(id: 1, title: "skip", count: 38, percent: 15.02),
                    Rating(id: 3, title: "meh", count: 25, percent: 9.88)
                ],
                ratingsCount: 244,
                reviewsTextCount: 8,
                added: 2101,
                playtime: 329,
                suggestionsCount: 544,
                updated: "2024-07-20T01:24:37",
                reviewsCount: 253,
                platforms: [
                    PlatformElement(
                        platform: PlatformPlatform(
                            id: 187,
                            name: "PlayStation 5",
                            slug: "playstation5",
                            image: nil,
                            imageBackground: "https://media.rawg.io/media/games/9f1/9f1891779cb20f44de93cef33b067e50.jpg"
                        ),
                        releasedAt: nil
                    ),
                    PlatformElement(
                        platform: PlatformPlatform(
                            id: 186,
                            name: "Xbox Series S/X",
                            slug: "xbox-series-x",
                            image: nil,
                            imageBackground: "https://media.rawg.io/media/games/5eb/5eb49eb2fa0738fdb5bacea557b1bc57.jpg"
                        ),
                        releasedAt: nil
                    ),
                    PlatformElement(
                        platform: PlatformPlatform(
                            id: 4,
                            name: "PC",
                            slug: "pc",
                            image: nil,
                            imageBackground: "https://media.rawg.io/media/games/26d/26d4437715bee60138dab4a7c8c59c92.jpg"
                        ),
                        releasedAt: nil
                    ),
                    PlatformElement(
                        platform: PlatformPlatform(
                            id: 1,
                            name: "Xbox One",
                            slug: "xbox-one",
                            image: nil,
                            imageBackground: "https://media.rawg.io/media/games/34b/34b1f1850a1c06fd971bc6ab3ac0ce0e.jpg"
                        ),
                        releasedAt: nil
                    ),
                    PlatformElement(
                        platform: PlatformPlatform(
                            id: 18,
                            name: "PlayStation 4",
                            slug: "playstation4",
                            image: nil,
                            imageBackground: "https://media.rawg.io/media/games/b45/b45575f34285f2c4479c9a5f719d972e.jpg"
                        ),
                        releasedAt: nil
                    )
                ],
                genres: [
                    Genre(
                        id: 4,
                        name: "Action",
                        slug: "action",
                        gamesCount: 181385,
                        imageBackground: "https://media.rawg.io/media/games/fc1/fc1307a2774506b5bd65d7e8424664a7.jpg",
                        domain: nil,
                        language: nil
                    ),
                    Genre(
                        id: 5,
                        name: "RPG",
                        slug: "role-playing-games-rpg",
                        gamesCount: 56682,
                        imageBackground: "https://media.rawg.io/media/games/e6d/e6de699bd788497f4b52e2f41f9698f2.jpg",
                        domain: nil,
                        language: nil
                    )
                ],
                stores: [
                    Store(
                        id: 304759,
                        store: Genre(
                            id: 5,
                            name: "GOG",
                            slug: "gog",
                            gamesCount: 6244,
                            imageBackground: "https://media.rawg.io/media/games/6cd/6cd653e0aaef5ff8bbd295bf4bcb12eb.jpg",
                            domain: "gog.com",
                            language: nil
                        )
                    ),
                    Store(
                        id: 305368,
                        store: Genre(
                            id: 11,
                            name: "Epic Games",
                            slug: "epic-games",
                            gamesCount: 1342,
                            imageBackground: "https://media.rawg.io/media/games/1bd/1bd2657b81eb0c99338120ad444b24ff.jpg",
                            domain: "epicgames.com",
                            language: nil
                        )
                    ),
                    Store(
                        id: 304767,
                        store: Genre(
                            id: 1,
                            name: "Steam",
                            slug: "steam",
                            gamesCount: 96746,
                            imageBackground: "https://media.rawg.io/media/games/d58/d588947d4286e7b5e0e12e1bea7d9844.jpg",
                            domain: "store.steampowered.com",
                            language: nil
                        )
                    )
                ],
                tags: [
                    Genre(
                        id: 31,
                        name: "Singleplayer",
                        slug: "singleplayer",
                        gamesCount: 225549,
                        imageBackground: "https://media.rawg.io/media/games/d82/d82990b9c67ba0d2d09d4e6fa88885a7.jpg",
                        domain: nil,
                        language: "eng"
                    ),
                    Genre(
                        id: 40847,
                        name: "Steam Achievements",
                        slug: "steam-achievements",
                        gamesCount: 38816,
                        imageBackground: "https://media.rawg.io/media/games/f46/f466571d536f2e3ea9e815ad17177501.jpg",
                        domain: nil,
                        language: "eng"
                    ),
                    Genre(
                        id: 40836,
                        name: "Full controller support",
                        slug: "full-controller-support",
                        gamesCount: 18400,
                        imageBackground: "https://media.rawg.io/media/games/157/15742f2f67eacff546738e1ab5c19d20.jpg",
                        domain: nil,
                        language: "eng"
                    )
                ],
                shortScreenshots: [
                    ShortScreenshot(id: -1, image: "https://media.rawg.io/media/games/fb5/fb5e0fdb1f6bb0e8b5da5d08bb83a5fc.jpg"),
                    ShortScreenshot(id: 1886815, image: "https://media.rawg.io/media/screenshots/831/8314575622c6ac8de538e890ec6a2aab.jpg"),
                    ShortScreenshot(id: 1886816, image: "https://media.rawg.io/media/screenshots/eb7/eb7d75e25be2c76d6e1bd454f2071aad.jpg"),
                    ShortScreenshot(id: 1886818, image: "https://media.rawg.io/media/screenshots/b71/b71ee1cd39f5e8685900b47980d715a1_I3dtqc6.jpg"),
                    ShortScreenshot(id: 1886819, image: "https://media.rawg.io/media/screenshots/291/29185669bd2fdf8c0ec10fcf10da3063.jpg")
                ], communityRating: 2
            )
        ],
        gamesCount: 0,
        reviewsCount: 0,
        recommendationsCount: 0
    )
    
    
    
    let platform: PlatformsEntity = PlatformsEntity(count: 0, next: nil, previous: nil, results: [PlatformResult(id: 0, name: "", slug: "", platforms: [
        
        PlatformValue(
                id: 187,
                name: "PlayStation 5",
                slug: "playstation5", gamesCount: 2,
                imageBackground: "https://media.rawg.io/media/games/9f1/9f1891779cb20f44de93cef33b067e50.jpg", image: nil
           
        ),
        PlatformValue(
                id: 186,
                name: "Xbox Series S/X",
                slug: "xbox-series-x",
                gamesCount: 2,
                imageBackground: "https://media.rawg.io/media/games/5eb/5eb49eb2fa0738fdb5bacea557b1bc57.jpg", image: nil
           
        ),
        PlatformValue(
                id: 4,
                name: "PC",
                slug: "pc",
                gamesCount: 2,
                imageBackground: "https://media.rawg.io/media/games/26d/26d4437715bee60138dab4a7c8c59c92.jpg", image: nil
           
        ),
        PlatformValue(
                id: 1,
                name: "Xbox One",
                slug: "xbox-one",
                gamesCount: 2,
                imageBackground: "https://media.rawg.io/media/games/34b/34b1f1850a1c06fd971bc6ab3ac0ce0e.jpg", image: nil
           
        ),
        PlatformValue(
                id: 18,
                name: "PlayStation 4",
                slug: "playstation4",
                gamesCount: 2,
                imageBackground: "https://media.rawg.io/media/games/b45/b45575f34285f2c4479c9a5f719d972e.jpg", image: nil
            ),
            
       ])])
    
}
