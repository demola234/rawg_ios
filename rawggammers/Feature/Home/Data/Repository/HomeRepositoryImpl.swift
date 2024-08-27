//
//  HomeRepositoryImpl.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


/// A concrete implementation of the `HomeRepository` protocol, responsible for providing game-related data through Combine publishers.
class HomeRepositoryImpl: HomeRepository {

    /// Shared instance for singleton access.
    static let shared = HomeRepositoryImpl()
    
    /// Fetches a list of games based on various parameters.
    /// - Parameters:
    ///   - discover: A Boolean value indicating whether to discover new games.
    ///   - ordering: A string specifying the ordering of the games.
    ///   - filter: A Boolean value indicating whether to apply filters.
    ///   - page: The page number for pagination.
    /// - Returns: A publisher that emits a `GamesEntity` object or an `Error`.
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int) -> AnyPublisher<GamesEntity, Error> {
        return Future<GamesEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getGames(discover: discover, ordering: ordering, filter: filter, page: page) { result in
                switch result {
                case .success(let games):
                    promise(.success(games))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches a list of platforms.
    /// - Returns: A publisher that emits a `PlatformsEntity` object or an `Error`.
    func getPlatForms() -> AnyPublisher<PlatformsEntity, Error> {
        return Future<PlatformsEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getPlatForms() { result in
                switch result {
                case .success(let platforms):
                    promise(.success(platforms))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches the best games for a specific year based on various parameters.
    /// - Parameters:
    ///   - year: The year to fetch the best games for.
    ///   - discover: A Boolean value indicating whether to discover new games.
    ///   - ordering: A string specifying the ordering of the games.
    ///   - page: The page number for pagination.
    /// - Returns: A publisher that emits a `GamesEntity` object or an `Error`.
    func getBestGames(year: Int, discover: Bool, ordering: String, page: Int) -> AnyPublisher<GamesEntity, Error> {
        return Future<GamesEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getBestGames(year: year, discover: discover, ordering: ordering, page: page) { result in
                switch result {
                case .success(let games):
                    promise(.success(games))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches games available on a specific platform.
    /// - Parameters:
    ///   - platform: The identifier of the platform to fetch games for.
    ///   - page: The page number for pagination.
    /// - Returns: A publisher that emits a `GamesEntity` object or an `Error`.
    func getGamesByPlatform(platform: Int, page: Int) -> AnyPublisher<GamesEntity, Error> {
        return Future<GamesEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getGamesByPlatform(platform: platform, page: page) { result in
                switch result {
                case .success(let games):
                    promise(.success(games))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches the best games from the last year based on various parameters.
    /// - Parameters:
    ///   - year: The year to fetch the best games from.
    ///   - discover: A Boolean value indicating whether to discover new games.
    ///   - ordering: A string specifying the ordering of the games.
    ///   - page: The page number for pagination.
    /// - Returns: A publisher that emits a `GamesEntity` object or an `Error`.
    func getBestGameLastYear(year: Int, discover: Bool, ordering: String, page: Int) -> AnyPublisher<GamesEntity, Error> {
        return Future<GamesEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getBestGameLastYear(year: year, discover: discover, ordering: ordering, page: page) { result in
                switch result {
                case .success(let games):
                    promise(.success(games))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches movies related to a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch movies for.
    /// - Returns: A publisher that emits a `MoviesEntity` object or an `Error`.
    func getMovies(game: String) -> AnyPublisher<MoviesEntity, Error> {
        return Future<MoviesEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getMovies(game: game) { result in
                switch result {
                case .success(let movies):
                    promise(.success(movies))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches detailed information about a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch details for.
    /// - Returns: A publisher that emits a `ResultData` object or an `Error`.
    func getGameDetails(game: String) -> AnyPublisher<ResultData, Error> {
        return Future<ResultData, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getGameDetails(game: game) { result in
                switch result {
                case .success(let game):
                    promise(.success(game))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches screenshots for a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch screenshots for.
    /// - Returns: A publisher that emits a `GameScreenShotsEntity` object or an `Error`.
    func getScreenShots(game: String) -> AnyPublisher<GameScreenShotsEntity, Error> {
        return Future<GameScreenShotsEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getScreenShots(game: game) { result in
                switch result {
                case .success(let screenshots):
                    promise(.success(screenshots))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Fetches the series of a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch the series for.
    /// - Returns: A publisher that emits a `GamesEntity` object or an `Error`.
    func getGameSeries(game: String) -> AnyPublisher<GamesEntity, Error> {
        return Future<GamesEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getGameSeries(game: game) { result in
                switch result {
                case .success(let gameSeries):
                    promise(.success(gameSeries))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
