//
//  Movie.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import Foundation

struct Movie: Codable, Identifiable {
    var id: String {
        return trackName + primaryGenreName
    }
    let trackName: String
    var artworkUrl100: String?
    let artistName: String?
    let releaseDate: String?
    var trackPrice: Float?
    var primaryGenreName: String
    var shortDescription: String?
    var longDescription: String?
}
