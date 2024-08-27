//
//  HomeRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
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
    func getScreenShots(game: String) -> AnyPublisher<GameScreenShotsEntity, Error>
    func getGameSeries(game: String) -> AnyPublisher<GamesEntity, Error>
}
