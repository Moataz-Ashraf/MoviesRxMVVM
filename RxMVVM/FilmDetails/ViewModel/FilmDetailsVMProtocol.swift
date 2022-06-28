//
//  hf.swift
//  RxMVVM
//
//  Created by Moataz on 27/06/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol FilmDetailsVMProtocol: AnyObject {
    var EnableBuObservable : Observable<Bool> { get }
    var ErrorObservable : Observable<String> { get }
    var FilmKey: String { get }

    func getData(CurFilmID: Int) async
}
