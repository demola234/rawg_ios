//
//  HomeRepositoryImpl.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


class HomeRepositoryImpl: HomeRepository {

    
    static let shared = HomeRepositoryImpl()
    
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
    
    
    func getPlatForms() -> AnyPublisher<PlatformsEntity, Error> {
        return Future<PlatformsEntity, Error> { promise in
            HomeRemoteDataSourceImpl.shared.getPlatForms() { result in
                switch result  {
                case .success(let platforms):
                    promise(.success(platforms))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
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
