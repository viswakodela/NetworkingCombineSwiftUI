//
//  RemoteImageView.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import Foundation
import SwiftUI

public struct RemoteImageView : View {
    @ObservedObject public var imageModel: ImageModel
    @State private var imageOpacity: Double = 0.0
    public var placeholder: Image
    
    public init(stringURL: String, placeholder: Image = Image("image_placeholder")) {
        self.placeholder = placeholder

        if let url = URL(string: stringURL) {
            imageModel = ImageModel(url: url)
            return
        }
        imageModel = ImageModel(url: nil)
    }
    
    public var body: some View {
        if let image = imageModel.image {
            Image(uiImage: image)
                .resizable()
                .opacity(imageOpacity)
                .animation(.easeInOut(duration: 0.6), value: imageOpacity)
                .cornerRadius(12)
                .frame(width: 80, height: 80)
                .onAppear {
                    withAnimation {
                        imageOpacity = 1
                    }
                }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(width: 80, height: 80)
        }
//        imageModel
//            .image
//            .map { Image(uiImage: $0).resizable().renderingMode(.original) }
//        ?? ProgressView().progressViewStyle(.circular)
    }
    
}
