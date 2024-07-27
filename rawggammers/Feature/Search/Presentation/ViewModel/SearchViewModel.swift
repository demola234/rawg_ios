//
//  SearchViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchData: SearchEntity?
    @Published var isSearchLoading: Bool = false
    @Published var errorMessage: String
    @Published var searchText: String = ""
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    
    
    private let repository: SearchRepository
    private var cancellables = Set<AnyCancellable>()
    
    
    init(repository: SearchRepository = SearchRepositoryImpl.shared, errorMessage: String = "", searchData: SearchEntity? = nil, isSearchLoading: Bool = false) {
        self.repository = repository
        self.errorMessage = errorMessage
        self.searchData = searchData
        self.isSearchLoading = isSearchLoading
        getAllSavedSearches()
    }
    
    func searchGames() {
        guard searchText.isEmpty else {
                    return
                }
        isSearchLoading = true
        repository.searchGames(query: searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.isSearchLoading = false
                }
            } receiveValue: { [weak self] searchData in
                self?.searchData = searchData
                self?.isSearchLoading = false
                print("Search Data: \(searchData)")
            }
            .store(in: &cancellables)
    }
    
    func saveSearch(index: Int) {
        guard let searchData = searchData else { return }
        let search = SearchDataEntity(
            slug: searchData.results?[index].slug,
            name: searchData.results?[index].name,
            backgroundImage: searchData.results?[index].backgroundImage,
            updated: searchData.results?[index].updated,
            id: searchData.results?[index].id
        )
        
        repository.saveSearch(query: search)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                print("Search saved successfully")
            }
            .store(in: &cancellables)
    }
    
    func getAllSavedSearches() {
        repository.getAllSavedSearches()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { searches in
                print("Saved Searches: \(searches)")
            }
            .store(in: &cancellables)
    }
    
    func deleteSearch(index: Int) {
        guard let searchData = searchData else { return }
        let search = SearchDataEntity(
            slug: searchData.results?[index].slug,
            name: searchData.results?[index].name,
            backgroundImage: searchData.results?[index].backgroundImage,
            updated: searchData.results?[index].updated,
            id: searchData.results?[index].id
        )
        
        repository.deleteSearch(query: search)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                print("Search deleted successfully")
            }
            .store(in: &cancellables)
    }
}
