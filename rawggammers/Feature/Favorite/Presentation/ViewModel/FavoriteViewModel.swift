//
//  FavoriteViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine

/// The view model responsible for managing the state of favorite entities.
///
/// This view model interacts with the repository to perform operations related to favorites, such as saving, retrieving, and deleting. It also handles state updates and error messaging.
class FavoriteViewModel: ObservableObject {
    
    /// The repository used for performing favorite-related operations.
    private let favoriteRepository: FavoriterRepository
    
    /// A set of cancellable publishers for managing subscriptions.
    private var cancellables: Set<AnyCancellable> = []
    
    /// Indicates whether the current item is marked as a favorite.
    @Published var favoritePick: Bool = false
    
    /// The list of favorite entities.
    @Published var favorites: [FavoriteEntity] = []
    
    /// The currently selected favorite entity.
    @Published var selectedFavorites: FavoriteEntity?
    
    /// An error message to display in case of failure.
    @Published var errorMessage: String = ""
    
    /// A boolean indicating whether data is currently being loaded.
    @Published var isLoading: Bool = false
    
    /// Initializes the view model with a repository.
    /// - Parameter favoriteRepository: The repository used to interact with the data source. Defaults to `FavoriteRepositoryImpl.shared`.
    init(favoriteRepository: FavoriterRepository = FavoriteRepositoryImpl.shared) {
        self.favoriteRepository = favoriteRepository
        getAllFavorites()
    }
    
    /// Checks if a given name is marked as a favorite.
    /// - Parameter name: The name of the item to check.
    func checkIfFavorite(name: String) {
        favoriteRepository.checkIfFavorite(name: name)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { isFavorite in
                print("Is Favorite: \(isFavorite)")
                self.favoritePick = isFavorite
            }
            .store(in: &cancellables)
    }
    
    /// Saves a favorite entity to the repository.
    /// - Parameter favorite: The favorite entity to save.
    func saveFavorite(favorite: FavoriteEntity) {
        favoriteRepository.saveFavorite(favorite: favorite)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.favoritePick = true
                self.favorites = []
                self.getAllFavorites()
            }
            .store(in: &cancellables)
    }
    
    /// Retrieves all favorite entities from the repository.
    func getAllFavorites() {
        self.isLoading = true
        favoriteRepository.getAllFavorites()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] favorite in
                guard let self = self else { return }
                self.favorites = favorite
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    /// Deletes a favorite entity from the repository.
    /// - Parameter favorite: The favorite entity to delete.
    func deleteFavorite(favorite: FavoriteEntity) {
        favoriteRepository.deleteFavorite(favorite: favorite)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.favoritePick = false
                self.favorites = []
                self.getAllFavorites()
            }
            .store(in: &cancellables)
    }
}
