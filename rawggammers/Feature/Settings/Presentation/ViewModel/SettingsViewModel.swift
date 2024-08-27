//
//  SettingsViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import Combine

/// ViewModel responsible for managing settings-related data and operations.
///
/// This view model interacts with the `SettingsRepository` to fetch and update user profile information.
/// It publishes changes to properties such as `user`, `errorMessage`, and loading states.
///
/// - Properties:
///   - `user`: The current user profile information.
///   - `errorMessage`: Error message string for displaying errors.
///   - `isLoading`: Boolean indicating if data is currently being loaded.
///   - `isUpdating`: Boolean indicating if the profile is being updated.
///   - `isUpdated`: Boolean indicating if the profile has been successfully updated.
///
/// - Methods:
///   - `init(repository:user:errorMessage:isLoading:isUpdating:isUpdated:)`: Initializes the view model with a repository and optional user and state parameters.
///   - `getProfileImage()`: Fetches the current user profile image from the repository.
///   - `updateProfileImage(image:)`: Updates the user's profile image and fetches the updated profile.
///   - `updateProfileName(name:)`: Updates the user's profile name and fetches the updated profile.
class SettingsViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isUpdating: Bool = false
    @Published var isUpdated: Bool = false
    
    private let repository: SettingsRepository
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes a `SettingsViewModel` instance with a specified repository and optional initial values.
    ///
    /// - Parameters:
    ///   - repository: The repository to use for fetching and updating settings data. Defaults to `SettingsRepositoryImpl.shared`.
    ///   - user: The initial user profile information. Defaults to `nil`.
    ///   - errorMessage: The initial error message string. Defaults to `""`.
    ///   - isLoading: Boolean indicating if data is currently being loaded. Defaults to `false`.
    ///   - isUpdating: Boolean indicating if the profile is being updated. Defaults to `false`.
    ///   - isUpdated: Boolean indicating if the profile has been successfully updated. Defaults to `false`.
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
    
    /// Fetches the current user profile image from the repository.
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
    
    /// Updates the user's profile image and fetches the updated profile.
    ///
    /// - Parameter image: The new profile image to set.
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
    
    /// Updates the user's profile name and fetches the updated profile.
    ///
    /// - Parameter name: The new profile name to set.
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
