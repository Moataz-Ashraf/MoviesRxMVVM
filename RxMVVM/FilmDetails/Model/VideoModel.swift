//
//  VideoModel.swift
//  RxMVVM
//
//  Created by Moataz on 13/04/2022.
//

import Foundation
struct VideoModel : Codable {
    let id : Int?
    let results : [result]?
}

    struct result : Codable {
        let iso_639_1 : String?
        let iso_3166_1 : String?
        let name : String?
        let key : String?
        let site : String?
        let size : Int?
        let type : String?
        let official : Bool?
        let published_at : String?
        let id : String?
    }
