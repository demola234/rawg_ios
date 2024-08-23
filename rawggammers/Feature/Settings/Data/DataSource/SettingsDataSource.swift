//
//  SettingsDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import Combine
import FirebaseFirestore


protocol SettingsRemoteDataSource {
    func getProfileImage(completion: @escaping (Result<User, Error>) -> Void)
    func updateProfileImage(image: String, completion: @escaping (Result<Void, Error>) -> Void)
//    updateProfileName
    func updateProfileName(name: String, completion: @escaping (Result<Void, Error>) -> Void)
}

struct SettingsRemoteDataSourceImpl: SettingsRemoteDataSource {
    
    
    static let shared = SettingsRemoteDataSourceImpl()
    
    private init() {}
    
    private var db = Firestore.firestore()
    
    func getProfileImage(completion: @escaping (Result<User, Error>) -> Void) {
        UserManager.shared.getUser() { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfileImage(image: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("SettingsRemoteDataSourceImpl: \(image)")
        UserManager.shared.uploadImageToFirebase(image: image) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfileName(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        UserManager.shared.updateProfileName(name: name) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
