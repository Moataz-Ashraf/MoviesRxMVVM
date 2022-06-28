//
//  HomeModel.swift
//  RxMVVM
//
//  Created by Moataz on 04/01/2022.
//

import Foundation

struct HomeModel{
    let data: HomeData?
    let statusCode: Int?


}

// MARK: - DataClass
struct HomeData: Codable {
    let id: Int?
    let title: String?
}
