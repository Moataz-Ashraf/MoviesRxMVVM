//
//  ApiService.swift
//  RxMVVM
//
//  Created by Moataz on 01/01/2022.
//

import Foundation


protocol RequestHandle {
    func send<T:Codable>(_ decodable: T.Type) async throws -> T
}

extension RequestHandle where Self: RequestBuilder {
    func send<T:Codable>(_ decodable: T.Type) async throws -> T {

        let (data, _) = try await URLSession.shared.dataa(from: urlRequest)
        do {
            return try JSONDecoder().decode(T.self, from: data)

        } catch {
            debugPrint(error)
            throw APIError.DecodingError

        }
    }
}

