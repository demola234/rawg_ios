//
//  SettingsRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import Combine
import FirebaseAuth

struct SettingsRepositoryImpl: SettingsRepository {

    
    
    static let shared = SettingsRepositoryImpl()
    
    private init() {}
    
    private let remoteDataSource: SettingsRemoteDataSource = SettingsRemoteDataSourceImpl.shared
    
    func getProfileImage() -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            SettingsRemoteDataSourceImpl.shared.getProfileImage { result in
                switch result {
                case .success(let profileImage):
                    promise(.success(profileImage))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateProfileImage(image: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            SettingsRemoteDataSourceImpl.shared.updateProfileImage(image: image) { result in
                switch result {
                case .success(let profileImage):
                    promise(.success(profileImage))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateProfileName(name: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            SettingsRemoteDataSourceImpl.shared.updateProfileName(name: name) { result in
                switch result {
                case .success(let profileName):
                    promise(.success(profileName))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
       
}


    
