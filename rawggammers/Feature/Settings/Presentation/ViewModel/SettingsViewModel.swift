//
//  SettingsViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import Combine



class SettingsViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isUpdating: Bool = false
    @Published var isUpdated: Bool = false
    
    private let repository: SettingsRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: SettingsRepository = SettingsRepositoryImpl.shared, user: User? = nil, errorMessage: String = "", isLoading: Bool = false, isUpdating: Bool = false, isUpdated: Bool = false) {
        self.repository = repository
        self.user = user
        self.errorMessage = errorMessage
        self.isLoading = isLoading
        self.isUpdating = isUpdating
        self.isUpdated = isUpdated
        
        if user == nil {
            getProfileImage()
        }
    }
    
    func getProfileImage() {
        isLoading = true
        repository.getProfileImage()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    self.isLoading = false
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    func updateProfileImage(image: String) {
        isUpdating = true
        repository.updateProfileImage(image: image)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error updating profile image: \(error.localizedDescription)")
                    self.isUpdating = false
                case .finished:
                    self.isUpdating = false
                    self.isUpdated = true
                    self.getProfileImage()
                }
            } receiveValue: { _ in
                print("Profile image updated")
                self.user = nil
                self.getProfileImage()
            }
            .store(in: &cancellables)
    }
    
    func updateProfileName(name: String) {
        isUpdating = true
        repository.updateProfileName(name: name)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isUpdating = false
                case .finished:
                    self.isUpdating = false
                    self.isUpdated = true
                }
            } receiveValue: { _ in
                self.user = nil
                self.getProfileImage()
            }
            .store(in: &cancellables)
    }
}
