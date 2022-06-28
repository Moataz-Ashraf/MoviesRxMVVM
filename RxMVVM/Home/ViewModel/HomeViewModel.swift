//
//  HomeViewModel.swift
//  RxMVVM
//
//  Created by Moataz on 04/01/2022.
//

import RxCocoa
import RxSwift

class HomeViewModel: HomeVMProtocol {
    
    deinit{
        print("HomeViewModel")
    }
    private var FilmsModelSubject = BehaviorRelay<[Results]>(value: [])
    var FilmsModelObservable: Observable<[Results]> {
        return FilmsModelSubject.asObservable()
    }

    private var NowPlayingPage = BehaviorRelay<Int>(value: 1)
    var NowPlayingPageObservable: Observable<Int> {
        return NowPlayingPage.asObservable()
    }

    private var CategoryPage = BehaviorRelay<Int>(value: 1)
    var CategoryPageObservable: Observable<Int> {
        return CategoryPage.asObservable()
    }

    private var FilmsCategory = BehaviorRelay<String>(value:"top_rated")
    var FilmsCategoryObservable: Observable<String> {
        return  FilmsCategory.asObservable()
    }

    private(set) var FilmsLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    private var TopFilmsModelSubject = BehaviorRelay<[Results]>(value: [])
    var TopFilmsModelObservable : Observable<[Results]> {
        return TopFilmsModelSubject.asObservable()
    }
    
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var LoadingObservable : Observable<Bool> {
        return loadingBehavior.asObservable()
    }

    private var ErrorBehavior = PublishRelay<String>()
    var ErrorObservable : Observable<String> {
        return ErrorBehavior.asObservable()
    }


    func IncreaseNowPlayingPage() {
        self.NowPlayingPage.accept(self.NowPlayingPage.value+1)
    }

    func IncreaseCategoryPage() {
        self.CategoryPage.accept(self.CategoryPage.value+1)
    }

    func ResetCategory() {
        self.CategoryPage.accept(1)
        self.FilmsModelSubject.accept([])
    }

    func setFilmCategory(category: String) {
        self.FilmsCategory.accept(category)
    }

    func LoadNowPlayingFilms() async {
        loadingBehavior.accept(true)
        FilmsLoading.accept(true)

        do {
            let topRatedFilms = try await UserRouter.TopRatedFilm(Page: NowPlayingPage.value).send(Films.self)

            TopFilmsModelSubject.accept(TopFilmsModelSubject.value+(topRatedFilms.results ?? [] ))
            FilmsLoading.accept(false)
            loadingBehavior.accept(false)

        }catch {
            FilmsLoading.accept(false)
            loadingBehavior.accept(false)
            guard let error = error as? APIError else { return }
            ErrorBehavior.accept(error.description)
        }
    }

    func LoadCategoryFilms() async {
        loadingBehavior.accept(true)
        FilmsLoading.accept(true)

        do {
            let films = try await UserRouter.AllFilmsByCatergory(category: FilmsCategory.value, Page: CategoryPage.value).send(Films.self)
            FilmsModelSubject.accept(FilmsModelSubject.value+(films.results ?? [] ))
            FilmsLoading.accept(false)
            loadingBehavior.accept(false)

        }catch {
            FilmsLoading.accept(false)
            loadingBehavior.accept(false)
            guard let error = error as? APIError else { return }
            ErrorBehavior.accept(error.description)

        }
    }
}





