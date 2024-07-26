//
//  SearchRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


protocol SearchRepository {
    func searchGames(query: String) -> AnyPublisher<SearchEntity, Error>
}
