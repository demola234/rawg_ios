//
//  SearchViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//
import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchData: [ResultData]?
    @Published var namedSearches: [SearchDataEntity]?
    @Published var isSearchLoading: Bool = false
    @Published var errorMessage: String
    @Published var searchText: String = ""
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    
    private var repository: SearchRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: SearchRepository = SearchRepositoryImpl.shared, errorMessage: String = "", searchData: [ResultData]? = nil, isSearchLoading: Bool = false) {
        self.repository = repository
        self.errorMessage = errorMessage
        self.searchData = searchData
        self.isSearchLoading = isSearchLoading
        getAllSavedSearches()
    }
    
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
    
    func loadMoreGames() {
        guard !searchText.isEmpty else {
            return
        }
        guard canLoadMore else { return }
        currentPage += 1
        searchGames()
    }
    
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
