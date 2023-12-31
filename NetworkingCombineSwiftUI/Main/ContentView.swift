//
//  ContentView.swift
//  NetworkingCombineSwiftUI
//
//  Created by kodelv3 on 2023-08-13.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    let searchApi: NetworkManager<SearchApi>
    init() {
        self.searchApi = NetworkManager<SearchApi>()
    }

    func fetchSearchResults() {
        searchApi
            .perform(request: .search("top gun"), decodableType: SearchResult.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("receiveCompletion --> \(completion)")
                case .failure(let error):
                    print("receiveCompletion \(error.localizedDescription)")
                }
            }, receiveValue: { searchResults in
                print(searchResults)
            })
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        TabView {
            MoviesView()
                .tabItem {
                    Label("Movies", systemImage: "play.tv.fill")
                }
            PodcastsView()
                .tabItem {
                    Label("Podcasts", systemImage: "beats.headphones")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
