//
//  MoviesViewModel.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let searchApi: NetworkManager<SearchApi>
    
    @Published var searchText: String = ""
    @Published var searchResults: [Movie] = []
    @Published var error: Error?
    
    init() {
        self.searchApi = NetworkManager<SearchApi>()
        setupObservables()
    }
    
    private func setupObservables() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .compactMap { searchText -> String? in
                guard !searchText.isEmpty else {
                    return nil
                }
                return searchText
            }
            .sink { [weak self] searchText in
                self?.fetchSearchResults(with: searchText)
            }
            .store(in: &cancellables)
    }

    func fetchSearchResults(with searchText: String) {
        searchApi
            .perform(request: .search(searchText), decodableType: SearchResult.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("receiveCompletion --> \(completion)")
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { [weak self] searchResults in
                self?.searchResults = searchResults.results
            })
            .store(in: &cancellables)
    }
}
