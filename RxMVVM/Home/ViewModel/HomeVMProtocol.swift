//
//  HomeVMProtocol.swift
//  RxMVVM
//
//  Created by Moataz on 27/06/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeVMProtocol: AnyObject {
    var FilmsModelObservable: Observable<[Results]> { get }
    var NowPlayingPageObservable : Observable<Int> { get }
    var CategoryPageObservable : Observable<Int> { get }
    var FilmsCategoryObservable : Observable<String> { get }
    var FilmsLoading: BehaviorRelay<Bool> { get }
    var TopFilmsModelObservable : Observable<[Results]> { get }
    var LoadingObservable : Observable<Bool> { get }
    var ErrorObservable : Observable<String> { get }

    func IncreaseNowPlayingPage()
    func IncreaseCategoryPage()
    func ResetCategory()
    func setFilmCategory(category: String)
    func LoadNowPlayingFilms() async
    func LoadCategoryFilms() async
}
