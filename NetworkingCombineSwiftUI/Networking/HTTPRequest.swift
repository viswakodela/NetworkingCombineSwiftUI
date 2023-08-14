//
//  HTTPRequest.swift
//  NetworkingCombineSwiftUI
//
//  Created by kodelv3 on 2023-08-13.
//

import Foundation

enum SearchApi {
    case search(_ searchText: String)
}

extension SearchApi: HTTPRequest {
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }

    var header: HTTPHeaders? {
        nil
    }

    var parameters: Parameters? {
        switch self {
        case .search(let text):
            return ["term": text,
                    "country": "US",
                    "media": "movie",
                    "offset": 1,
                    "limit": 20]
        }
    }

    var httpTask: HTTPTask {
        switch self {
        case .search:
            return .requestParameters(bodyParameters: nil, urlParameters: parameters)
        }
    }
}

protocol HTTPRequest {
    var path: String { get }
    var baseUrl: String { get }
    var httpMethod: HTTPMethod { get }
    var header: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var httpTask: HTTPTask { get }
}

extension HTTPRequest {

    /// Helps build the url for the given *Endpoint*
    /// - Parameter route: ...
    func buildRequest() throws -> URLRequest {
        guard let baseUrl = URL(string: baseUrl) else {
            throw NetworkError.invalidUrl
        }
        var request = URLRequest(url: baseUrl.appendingPathComponent(path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = header

        do {
            switch httpTask {
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)

            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    /// Adds the parameters to the *URLRequest* if they are non nil
    /// - Parameters:
    ///   - bodyParameters: bodyParameters defaulted with `nil`
    ///   - urlParameters: urlParameters defaulted with `nil`
    ///   - httpBody: httpBody defaulted with `nil`
    ///   - request: *URLRequest*
    private func configureParameters(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }

            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        }
    }

    /// Adds headers to the *URLRequest*
    /// - Parameters:
    ///   - additionalHeaders: headers that will be added.
    ///   - request: *URLRequest*
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

/// **HTTPTask** will help to choose the required case according to the *urlParameters*, *bodyParameters* and *additionalHeaders* we specify to create the URL
enum HTTPTask {
    case requestParameters(bodyParameters: Parameters? = nil,
                           urlParameters: Parameters? = nil)

    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}


extension HTTPRequest {
    var baseUrl: String {
        return "https://itunes.apple.com"
    }
}
