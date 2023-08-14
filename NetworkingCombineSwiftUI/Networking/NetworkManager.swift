//
//  NetworkManager.swift
//  NetworkingCombineSwiftUI
//
//  Created by kodelv3 on 2023-08-13.
//

import Foundation
import Combine

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

struct NetworkManager<H: HTTPRequest> {

    let urlSession: URLSession

    init(configuration: URLSessionConfiguration = .ephemeral) {
        urlSession = URLSession(configuration: configuration)
    }

    func perform<T: Codable>(request: H, decodableType: T.Type,
                             dispatchQueue: DispatchQueue = .main,
                             decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, NetworkError> where T: Decodable, T: Encodable {
        guard let url = try? request.buildRequest() else {
            return AnyPublisher(
                Fail(error: NetworkError.invalidUrl)
                    .eraseToAnyPublisher()
            )
        }
        
        print(url)

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                if let httpReponse = response as? HTTPURLResponse {
                    switch httpReponse.statusCode {
                    case 200..<300:
                        return data
                    case 401:
                        throw NetworkError.unauthorized
                    case 400:
                        throw NetworkError.badRequest
                    case 500:
                        throw NetworkError.serviceError
                    default:
                        throw NetworkError.invalidResponse
                    }
                } else {
                    throw NetworkError.invalidResponse
                }
            }
            .tryMap { data in
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingFailed(error)
                }
            }
            .mapError { error in
                if let error = error as? NetworkError {
                    return error
                } else {
                    return NetworkError.decodingFailed(error)
                }
            }
            .receive(on: dispatchQueue)
            .eraseToAnyPublisher()
    }
}
