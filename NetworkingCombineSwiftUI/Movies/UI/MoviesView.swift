//
//  MoviesView.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import SwiftUI

struct MoviesView: View {
    
    @StateObject var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.searchResults.isEmpty {
                Text("Search for Movie")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(viewModel.searchResults, id: \.id) { item in
                        HStack {
                            RemoteImageView(stringURL: item.artworkUrl100 ?? "")
                                .scaledToFit()
                            Text(item.trackName)
                        }
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
