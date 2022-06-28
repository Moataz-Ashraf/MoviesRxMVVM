//
//  UserRouter.swift
//  RxMVVM
//
//  Created by Moataz on 27/06/2022.
//

import Foundation

enum UserRouter: RequestBuilder {

    // MARK: -Cases
    case TopRatedFilm(Page: Int)
    case AllFilmsByCatergory(category: String, Page: Int)
    case FilmByID(Id: Int)

    // MARK: -Path
    var path: String {
        switch self {
        case .TopRatedFilm:
            return "/movie/now_playing"
        case .AllFilmsByCatergory(let category, _):
            return "/movie/\(category)"
        case .FilmByID(let Id):
            return "/movie/\(Id)/videos"

        }
    }

    // MARK: -Method
    var method: HTTPMethod {
        switch self {

        default:
            return HTTPMethod.get

        }
    }

    // MARK: -Parameters
    var parameters: [String : Any]? {
        switch self {
        case .TopRatedFilm(let Page):
            return ["api_key": apiKey, "page": Page]
        case .AllFilmsByCatergory(_, let Page):
            return ["api_key": apiKey, "page": Page]
        default:
            return ["api_key": apiKey]

        }
    }

    // MARK: -Headers
    var headers: [String : String]? {
        switch self {

        default:
            return [:]

        }
    }

}
