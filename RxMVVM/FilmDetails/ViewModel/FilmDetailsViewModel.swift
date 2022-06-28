//
//  FilmDetailsViewModel.swift
//  RxMVVM
//
//  Created by Moataz on 15/04/2022.
//

import RxCocoa
import RxSwift

class FilmDetailsViewModel: FilmDetailsVMProtocol {
    deinit{
        print("FilmDetailsViewModel")
    }
    
    private var EnableBu : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var EnableBuObservable : Observable<Bool> {
        return EnableBu.asObservable()
    }
    
    private(set) var FilmKey: String = ""

    private var ErrorBehavior = PublishRelay<String>()
    var ErrorObservable : Observable<String> {
        return ErrorBehavior.asObservable()
    }
    
    func getData(CurFilmID: Int) async {

        do {
            let film = try await UserRouter.FilmByID(Id: CurFilmID).send(VideoModel.self)
            guard film.results?.count ?? 0 > 0 else { return}
            guard let key = film.results?[0].key else { return}
            self.FilmKey = "https://www.youtube.com/embed/\(key)"
            self.EnableBu.accept(true)
        }catch {
            guard let error = error as? APIError else { return }
            self.EnableBu.accept(false)
            ErrorBehavior.accept(error.description)
        }

    }

}
