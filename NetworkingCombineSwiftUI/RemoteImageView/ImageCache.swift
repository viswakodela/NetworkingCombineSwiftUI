//
//  ImageCache.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import SwiftUI
import Combine
import UIKit

public class ImageCache {
    
    enum Error: Swift.Error {
        case dataConversionFailed
        case sessionError(Swift.Error)
    }
    
    static let shared = ImageCache()
    let cache = NSCache<NSURL, UIImage>()
        
    static func image(for url: URL) -> AnyPublisher<UIImage?, ImageCache.Error> {
        guard let image = shared.cache.object(forKey: url as NSURL) else {
            return URLSession
                .shared
                .dataTaskPublisher(for: url)
                .tryMap { (tuple) -> UIImage in
                    let (data, _) = tuple
                    guard let image = UIImage(data: data) else {
                        throw Error.dataConversionFailed
                    }
                    shared.cache.setObject(image, forKey: url as NSURL)
                    return image
            }
            .mapError({ error in Error.sessionError(error) })
            .eraseToAnyPublisher()
        }
        return Just(image)
            .mapError { error in
                return Error.sessionError(error)
            }
            .eraseToAnyPublisher()
    }
}
