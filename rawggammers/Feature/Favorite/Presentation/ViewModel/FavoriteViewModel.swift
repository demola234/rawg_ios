//
//  FavoriteViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine


class FavoriteViewModel: ObservableObject {
    
    private let favoriteRepository: FavoriterRepository
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var favorite: [FavoriteEntity] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    init(favoriteRepository: FavoriterRepository) {
        self.favoriteRepository = favoriteRepository
        getAllFavorites()
    }
    
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
                self.getAllFavorites()
            }
            .store(in: &cancellables)
    }
    
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
                self.favorite = favorite
            }
            .store(in: &cancellables)
    }
    
    func deleteFavorite(favorite: FavoriteEntity) {
        favoriteRepository.deleteFavorite(favorite: favorite)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.getAllFavorites()
            }
            .store(in: &cancellables)
    }
}
