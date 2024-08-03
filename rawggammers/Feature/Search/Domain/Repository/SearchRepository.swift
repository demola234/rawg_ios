//
//  SearchRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


protocol SearchRepository {
    func searchGames(query: String, page: Int) -> AnyPublisher<SearchEntity, Error>
    func saveSearch(query: SearchDataEntity) -> AnyPublisher<Bool, Error>
    func getAllSavedSearches() -> AnyPublisher<[SearchDataEntity], Error>
    func deleteSearch(query: SearchDataEntity) -> AnyPublisher<Bool, Error>
}
