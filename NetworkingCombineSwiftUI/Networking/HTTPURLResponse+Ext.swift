//
//  HTTPURLResponse+Ext.swift
//  NetworkingCombineSwiftUI
//
//  Created by Viswa Kodela on 2023-08-13.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        return 200..<300 ~= statusCode
    }

    var unauthorized: Bool {
        return 401 == statusCode
    }

    var badRequest: Bool {
        return 400 == statusCode
    }

    var internalServerError: Bool {
        return 500 == statusCode
    }
}
