//
//  SearchViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

/// ViewModel for managing search operations and data within the application.
///
/// This class handles the logic for searching games, loading more results, saving and deleting search queries, and managing the state of search-related data.
class SearchViewModel: ObservableObject {
    
    /// The search results data, which is an array of `ResultData`.
    @Published var searchData: [ResultData]?
    
    /// The list of saved search queries.
    @Published var namedSearches: [SearchDataEntity]?
    
    /// A boolean indicating whether a search operation is currently loading.
    @Published var isSearchLoading: Bool = false
    
    /// An error message to display in case of an error during search operations.
    @Published var errorMessage: String
    
    /// The text entered in the search field.
    @Published var searchText: String = ""
    
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    
    private var repository: SearchRepository
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the `SearchViewModel` with a specified repository and optional initial values.
    ///
    /// - Parameters:
    ///   - repository: The `SearchRepository` instance used for search operations. Defaults to `SearchRepositoryImpl.shared`.
    ///   - errorMessage: The initial error message. Defaults to an empty string.
    ///   - searchData: The initial search data. Defaults to `nil`.
    ///   - isSearchLoading: Indicates whether a search operation is currently loading. Defaults to `false`.
    init(repository: SearchRepository = SearchRepositoryImpl.shared, errorMessage: String = "", searchData: [ResultData]? = nil, isSearchLoading: Bool = false) {
        self.repository = repository
        self.errorMessage = errorMessage
        self.searchData = searchData
        self.isSearchLoading = isSearchLoading
        getAllSavedSearches()
    }
    
    /// Performs a search for games based on the current search text and page number.
    func searchGames() {
        guard !searchText.isEmpty else {
            return
        }
        isSearchLoading = true
        repository.searchGames(query: searchText, page: currentPage)
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
                guard let self = self else { return }
                self.errorMessage = ""
                
                if self.currentPage == 1 {
                    self.searchData = searchData.results
                } else {
                    self.searchData?.append(contentsOf: searchData.results ?? [])
                }
                self.isSearchLoading = false
                self.canLoadMore = (searchData.count ?? 0) > 0
                print("Search Data: \(searchData)")
            }
            .store(in: &cancellables)
    }
    
    /// Loads more game results if available and the search text is not empty.
    func loadMoreGames() {
        guard !searchText.isEmpty else {
            return
        }
        guard canLoadMore else { return }
        currentPage += 1
        searchGames()
    }
    
    /// Saves a search query with the specified name.
    ///
    /// - Parameter name: The name of the search query to save.
    func saveSearch(name: String) {
        let search = SearchDataEntity(
           name: name
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
                self.getAllSavedSearches()
            }
            .store(in: &cancellables)
    }
    
    /// Retrieves all saved search queries from the repository.
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
                self.namedSearches = searches
                print("Saved Searches: \(searches)")
            }
            .store(in: &cancellables)
    }
    
    /// Deletes a saved search query.
    ///
    /// - Parameter searchData: The `SearchDataEntity` object representing the search query to delete.
    func deleteSearch(searchData: SearchDataEntity) {
        repository.deleteSearch(query: searchData)
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
                self.getAllSavedSearches()
            }
            .store(in: &cancellables)
    }
}
