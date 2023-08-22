//
//  ImageModel.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import Foundation
import Combine
import UIKit

public class ImageModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    var cacheSubscription: AnyCancellable?
    
    init(url: URL?) {
        guard let url = url else { return }
        cacheSubscription = ImageCache
            .image(for: url)
            .replaceError(with: nil)
            .receive(on: RunLoop.main, options: .none)
            .assign(to: \.image, on: self)
    }
}
