//
//  supporter.swift
//  RxMVVM
//
//  Created by Moataz on 27/06/2022.
//

import Foundation


extension URLSession {
    func dataa(from url: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation{ continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let response = response
                else {
                    continuation.resume(throwing: APIError.NoInternetConnection)
                    return
                }
                continuation.resume(returning: (data, response))
                return
            }
            .resume()
        }
    }
}

enum APIError: Error {
    case NoInternetConnection, DecodingError
    var description: String {
        switch self {
        case .NoInternetConnection:
            return "No Internet Connection"
        case .DecodingError:
            return "One of model dataType is changed"
        }
    }

}

enum HTTPMethod {
    case get
    case post

    var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }

}
