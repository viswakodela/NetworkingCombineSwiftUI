//
//  SearchResult.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import Foundation

struct SearchResult: Codable {
    let resultCount: Int
    let results: [Movie]
}
