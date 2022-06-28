//
//  RequestBuilder.swift
//  RxMVVM
//
//  Created by Moataz on 27/06/2022.
//

import Foundation

protocol RequestBuilder: RequestHandle {

    var baseUrl: URL { get }
    var apiKey: String { get }

    // MARK: - Path
    var path: String { get }

    // MARK: - Methods
    var method: HTTPMethod { get }

    // MARK: - Parameters
    var parameters: [String: Any]? { get }

    // MARK: - The headers to be used in the request.
    var headers: [String: String]? { get }

    // MARK: - URLRequest
    var urlRequest: URLRequest { get }

}

extension RequestBuilder {


    var baseUrl: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }

    var apiKey: String {
        return "SetYourKeyHere"
    }


    var urlRequest: URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters!.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}

