//
//  NetworkError.swift
//  NetworkingCombineSwiftUI
//
//  Created by kodelv3 on 2023-08-13.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case unauthorized
    case badRequest
    case serviceError
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}
