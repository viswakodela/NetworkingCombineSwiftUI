//
//  Result.swift
//  NetworkingCombineSwiftUI
//
//  Created by kodelv3 on 2023-08-13.
//

import Foundation

struct SearchResult: Codable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Codable {
    let wrapperType: String
}
