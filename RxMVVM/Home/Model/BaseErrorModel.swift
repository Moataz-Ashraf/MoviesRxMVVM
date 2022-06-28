//
//  BaseErrorModel.swift
//  RxMVVM
//
//  Created by Moataz on 30/03/2022.
//

import Foundation
import UIKit

struct BaseErrorModel: Codable {
    let message: String?
    let status_code: Int?
}
