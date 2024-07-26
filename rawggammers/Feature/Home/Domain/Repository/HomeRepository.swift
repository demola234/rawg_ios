//
//  HomeRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation


//https://api.rawg.io/api/platforms/lists/parents?key=8a275dde2a4f416e8931d049b981d6c4
//https://api.rawg.io/api/games/lists/main?discover=true&ordering=-relevance&key=8a275dde2a4f416e8931d049b981d6c4&filter=true
//https://api.rawg.io/api/games/lists/main?discover=true&ordering=-relevance&key=8a275dde2a4f416e8931d049b981d6c4&filter=true&page=1
//https://api.rawg.io/api/games/lists/main?discover=true&ordering=-relevance&key=8a275dde2a4f416e8931d049b981d6c4&filter=true&ordering=-name&page=1
//https://api.rawg.io/api/games?key=8a275dde2a4f416e8931d049b981d6c4&filter=true&dates=2024-01-01,2024-12-31&page=1
//https://api.rawg.io/api/games/lists/greatest?year=2023&discover=true&ordering=-added&page_size=20&key=8a275dde2a4f416e8931d049b981d6c4&filter=true&page=1
//https://api.rawg.io/api/games?parent_platforms=2&key=8a275dde2a4f416e8931d049b981d6c4&filter=true&page=1
//https://api.rawg.io/api/games?parent_platforms=2&key=8a275dde2a4f416e8931d049b981d6c4&filter=true
//https://api.rawg.io/api/games/grand-theft-auto-v/movies?key=8a275dde2a4f416e8931d049b981d6c4&filter=true
//https://api.rawg.io/api/games/vampire-the-masquerade-bloodlines-2/game-series?key=8a275dde2a4f416e8931d049b981d6c4&filter=true

import Combine


// MARK: - HomeRepository
protocol HomeRepository {
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int) -> AnyPublisher<GamesEntity, Error>
    func getPlatForms() -> AnyPublisher<PlatformsEntity, Error>
    func getBestGames(year: Int, discover: Bool, ordering: String, page: Int) -> AnyPublisher<GamesEntity, Error>
    func getGamesByPlatform(platform: Int, page: Int) -> AnyPublisher<GamesEntity, Error>
    func getBestGameLastYear(year: Int, discover: Bool, ordering: String, page: Int) -> AnyPublisher<GamesEntity, Error>
    func getMovies(game: String) -> AnyPublisher<MoviesEntity, Error>
    func getGameDetails(game: String) -> AnyPublisher<ResultData, Error>
    
}
