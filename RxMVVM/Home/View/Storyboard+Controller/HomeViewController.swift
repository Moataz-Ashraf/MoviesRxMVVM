//
//  HomeViewController.swift
//  RxMVVM
//
//  Created by Moataz on 04/01/2022.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    // MARK: - Main Members
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    
    @IBOutlet weak var FilmCollectionView: UICollectionView!
    
    @IBOutlet weak var TopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var BottomContentView: UIView!
    @IBOutlet weak var StackViewBu: UIStackView!
    @IBOutlet weak var ToRateBu: UIButton!
    @IBOutlet weak var PopulerBu: UIButton!
    @IBOutlet weak var UpComingBu: UIButton!
    
    @IBOutlet weak var filmTableView: UITableView!
    
    let bacgroundkView = UIImageView()
    
    private let HomeVM: HomeVMProtocol = HomeViewModel()
    private let DisposeBags = DisposeBag()

    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupMainView()
        setupTapButton()

        SubscribeLoading()
        NowPlayingPageSubscribe()
        CategoryFilmSubscribe()
        CategoryFilmSubscribe()
        CategoryPageSubscribe()
        ErrorSubscription()

        SubscribeCollectionViewItems()
        WillDisplayCell()
        DidScrollCollectionView()
        SelectedCollectionViewItems()
        
        SubscribeTableViewItems()
        SelectedTableViewItems()
        didScrollingTableView()
    }
    
    deinit{
        print("HomeView")
    }

    //MARK: - SetupUI Functions
    private
    func SetupMainView(){
        
        bacgroundkView.image = UIImage(named: "background")
        bacgroundkView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(bacgroundkView, at: 1)
        
        
        bacgroundkView.frame = view.bounds
        
        bacgroundkView.addBlurAreaForLoading(area: view.frame, style: .regular)
        
        
        self.TitleLabel.text = "Now Playing"
        self.FilmCollectionView.backgroundColor = .clear
        self.FilmCollectionView.register(UINib(nibName: "FilmCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: .FilmCollectionViewId)
        
        self.filmTableView.backgroundColor = .clear
        self.filmTableView.register(UINib(nibName: "FilmTableViewCell", bundle: nil), forCellReuseIdentifier: .FilmTableViewId)
        
        self.ToRateBu.backgroundColor = .red
        self.ToRateBu.layer.cornerRadius = 10
        self.PopulerBu.layer.cornerRadius = 10
        self.UpComingBu.layer.cornerRadius = 10
    }

    private
    func SetBuColors(TopRateC: UIColor ,PopulerBuC: UIColor ,UpComingBuC: UIColor){

        self.ToRateBu.backgroundColor = TopRateC
        self.PopulerBu.backgroundColor = PopulerBuC
        self.UpComingBu.backgroundColor = UpComingBuC
    }

    private
    func setupTapButton(){
        self.ToRateBu.rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe{[weak self] _ in
                
                guard let self = self else{return}
                self.SetBuColors(TopRateC: .red ,PopulerBuC: .placeholderText ,UpComingBuC: .placeholderText)

                self.HomeVM.setFilmCategory(category: "top_rated")
                
            }.disposed(by: DisposeBags)
        
        self.PopulerBu.rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe{[weak self] _ in
                
                guard let self = self else{return}
                self.SetBuColors(TopRateC: .placeholderText ,PopulerBuC: .red ,UpComingBuC: .placeholderText)

                self.HomeVM.setFilmCategory(category: "popular")
                
            }.disposed(by: DisposeBags)
        
        self.UpComingBu.rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe{[weak self] _ in
                
                guard let self = self else{return}
                self.SetBuColors(TopRateC: .placeholderText ,PopulerBuC: .placeholderText ,UpComingBuC: .red)

                self.HomeVM.setFilmCategory(category: "upcoming")
                
            }.disposed(by: DisposeBags)
    }

    
    //MARK: -Subscription Functions
    private
    func SubscribeLoading(){
        HomeVM.LoadingObservable
            .observe(on: MainScheduler.instance)
            .bind(to: self.rx.isAnimating).disposed(by: DisposeBags)
    }

    private
    func NowPlayingPageSubscribe() {
        HomeVM.NowPlayingPageObservable.subscribe(onNext: {_ in
            Task {
                await self.HomeVM.LoadNowPlayingFilms()
            }
        }).disposed(by: DisposeBags)
    }

    private
    func CategoryPageSubscribe() {
        HomeVM.CategoryPageObservable.subscribe(onNext: {_ in
            Task {
                await self.HomeVM.LoadCategoryFilms()
            }
        }).disposed(by: DisposeBags)
    }

    private
    func CategoryFilmSubscribe() {
        HomeVM.FilmsCategoryObservable.subscribe(onNext: {_ in
            self.HomeVM.ResetCategory()
        }).disposed(by: DisposeBags)
    }

    private
    func ErrorSubscription() {
        HomeVM.ErrorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] error in

                guard let self = self else { return }
                self.MAK_ShowToast(message: error )
                debugPrint(error)

            }).disposed(by: DisposeBags)
    }
    
    //MARK: -CollectionView Functions
    private
    func configrateCell(cell:filmsCollectionViewCell , data : Results){

        cell.films = data
        cell.clipsToBounds = true
        cell.withBackView = true
    }

    private
    func SubscribeCollectionViewItems() {
        HomeVM.TopFilmsModelObservable
            .observe(on: MainScheduler.instance)
            .bind(to: FilmCollectionView.rx.items(cellIdentifier: .FilmCollectionViewId, cellType: filmsCollectionViewCell.self)){ [weak self](index,films,cell) in
                guard let self = self else{ return}
                self.configrateCell(cell: cell, data: films)
            }.disposed(by: DisposeBags)
    }
    
    private
    func WillDisplayCell(){
        
        FilmCollectionView.rx.willDisplayCell
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: ({ (cell  ,indexPath) in
                let curCell = (cell as! filmsCollectionViewCell )
                curCell.contentView.transform =  CGAffineTransform(scaleX: 0.6, y: 0.6)
                
                UIView.animate(withDuration: 0.2, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.layer.transform = CATransform3DIdentity
                    curCell.contentView.transform =  CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
                
                self.bacgroundkView.image = curCell.FilmImage.image
                
            })).disposed(by: DisposeBags)
    }
    
    private
    func DidScrollCollectionView(){
        FilmCollectionView.rx.didScroll
            .observe(on: MainScheduler.instance)
            .subscribe{ [weak self] _ in
                guard let self = self else { return }
                let offSetX = self.FilmCollectionView.contentOffset.x
                let contentWidth = self.FilmCollectionView.contentSize.width
                
                if( offSetX > (contentWidth - self.FilmCollectionView.frame.size.width - 300)) &&  !self.HomeVM.FilmsLoading.value  {

                    self.HomeVM.IncreaseNowPlayingPage()
                }
                
            }.disposed(by: DisposeBags)
    }
    
    
    private
    func SelectedCollectionViewItems(){
        Observable
            .zip(FilmCollectionView.rx.itemSelected, FilmCollectionView.rx.modelSelected(Results.self))
            .observe(on: MainScheduler.instance)
            .subscribe{ index , selectedFilm in
                
                let vc = FilmDetailsVC(curFilm: selectedFilm)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
                
            }.disposed(by: DisposeBags)
        
    }
    
    //MARK: -TableView Functions
    private
    func configrateTableViewCell(cell:filmTableViewCell , data : Results){

        cell.films = data
        cell.clipsToBounds = true
    }

    private
    func SubscribeTableViewItems() {
        HomeVM.FilmsModelObservable
            .observe(on: MainScheduler.instance)
            .bind(to: filmTableView.rx.items(cellIdentifier: .FilmTableViewId, cellType: filmTableViewCell.self)){ [weak self](index,films,cell) in
                guard let self = self else{ return}
                self.configrateTableViewCell(cell: cell, data: films)
                
            }.disposed(by: DisposeBags)
    }
    
    private
    func didScrollingTableView(){
        filmTableView
            .rx
            .didScroll
            .observe(on: MainScheduler.instance)
            .subscribe{[weak self] offsetTV in
                guard let self = self else{ return}
                let offsetY = self.filmTableView.contentOffset.y
                let paddingTop = (self.FilmCollectionView.frame.height+95)
                
                
                let contentHeight = self.filmTableView.contentSize.height
                if (0...paddingTop) ~= offsetY  {
                    self.BottomContentView.backgroundColor = .darkGray.withAlphaComponent(0.1*offsetY)
                    self.TopLayoutConstraint.constant = -offsetY
                    
                }else  {
                    self.TopLayoutConstraint.constant = -paddingTop
                }
                
                if( offsetY > (contentHeight - self.filmTableView.frame.size.height - 300)) &&  !self.HomeVM.FilmsLoading.value  {

                    self.HomeVM.IncreaseCategoryPage()
                    
                }
            }.disposed(by: DisposeBags)
    }
    
    private
    func SelectedTableViewItems(){
        Observable
            .zip(filmTableView.rx.itemSelected, filmTableView.rx.modelSelected(Results.self))
            .observe(on: MainScheduler.instance)
            .bind { [weak self] selectedIndex,selectedFilm in
                guard let self = self else{ return}
                let vc = FilmDetailsVC(curFilm: selectedFilm)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }.disposed(by: DisposeBags)
    }
}


