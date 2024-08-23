//
//  SettingsRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import Combine


// MARK: - SettingsRepository
protocol SettingsRepository {
    func getProfileImage() -> AnyPublisher<User, Error>
    func updateProfileImage(image: String) -> AnyPublisher<Void, Error>
    func updateProfileName(name: String) -> AnyPublisher<Void, Error>
}

