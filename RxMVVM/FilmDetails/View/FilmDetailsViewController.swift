//
//  FilmDetailsViewController.swift
//  RxMVVM
//
//  Created by Moataz on 02/04/2022.
//

import UIKit
import Cosmos
import RxCocoa
import RxSwift
import WebKit

class FilmDetailsVC: UIViewController {
    
    // MARK: - Main Members
    @IBOutlet weak var FilmImg: UIImageView!
    @IBOutlet weak var BackBu: UIButton!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var PlayBu: UIButton!
    @IBOutlet weak var RateView: CosmosView!
    @IBOutlet weak var RateLabel: UILabel!
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var filmSubTitle: UITextView!
    @IBOutlet weak var filmDate: UILabel!
    @IBOutlet weak var filmDateView: UIView!
    
    private
    var UPView : UIView = {
        let v = UIView()
        v.backgroundColor = .darkText
        v.alpha = 0.95
        return v
    }()
    
    private
    var webView : WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: webConfiguration)
        wv.backgroundColor = .clear
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    private
    var DismissUPViewBu: UIButton = {
        let bu = UIButton()
        bu.setImage(UIImage(systemName: "xmark"), for: .normal)
        bu.translatesAutoresizingMaskIntoConstraints = false
        bu.layer.cornerRadius = 24
        bu.backgroundColor = .red
        bu.tintColor = .white
        return bu
    }()
    
    private let FilmDetailsVM: FilmDetailsVMProtocol = FilmDetailsViewModel()
    private let DisposeBags = DisposeBag()
    private var curFilm : Results

    // MARK: - override func
    init(curFilm: Results){
        self.curFilm = curFilm
        super.init(nibName: "FilmDetailsVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        ConfigureView()
        backBuAction()
        playBuAction()
        GetKey()
        EnableShowBuSubscription()

        ErrorSubscription()
        DismissBuSubscription()
        print(curFilm)
    }

    // MARK: - YoutubeView
    private
    func DrawUPView() {
        view.addSubview(UPView)
        UPView.frame = view.bounds
        UPView.addSubview(webView)
        UPView.addSubview(DismissUPViewBu)
        

        webView.heightAnchor.constraint(equalTo: UPView.heightAnchor, multiplier: 0.5).isActive = true
        webView.leadingAnchor.constraint(equalTo: UPView.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: UPView.trailingAnchor, constant: 0).isActive = true
        webView.centerYAnchor.constraint(equalTo: UPView.centerYAnchor).isActive = true
        
        DismissUPViewBu.widthAnchor.constraint(equalToConstant: 48).isActive = true
        DismissUPViewBu.heightAnchor.constraint(equalToConstant: 48).isActive = true
        DismissUPViewBu.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        DismissUPViewBu.bottomAnchor.constraint(equalTo: webView.topAnchor,constant: -35).isActive = true
    }
    
    private
    func DismissBuSubscription(){
        self.DismissUPViewBu.rx.tap.subscribe{[weak self] _ in
            guard let self = self else {return}
            self.UPView.removeFromSuperview()
            self.webView.removeFromSuperview()
            self.DismissUPViewBu.removeFromSuperview()
        }.disposed(by: DisposeBags)
    }

    // MARK: - DetailsView
    private
    func SetupUI(){
        view.backgroundColor = .darkText

        ContentView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        ContentView.layer.cornerRadius = 35
        ContentView.backgroundColor = .darkText
        BackBu.layer.cornerRadius = 24
        PlayBu.layer.cornerRadius = 10
        filmTitle.textColor = .white
        RateLabel.textColor = .white
        filmSubTitle.textColor = .gray
        filmDate.textColor = .red
        filmDateView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMaxYCorner]
        filmDateView.layer.cornerRadius = 15
        
    }
    
    private
    func ConfigureView(){
        let starRate = (((curFilm.vote_average ?? 0.00)/10.00)*5.00)
        
        RateView.rating = Double(starRate)
        RateView.settings.updateOnTouch = false
        RateLabel.text = String(format: "%.1f", starRate)
        
        FilmImg.loadImage(fromURL: "https://image.tmdb.org/t/p/w500\(curFilm.poster_path ?? "/2dfujXrxePtYJPiPHj1HkAFQvpu.jpg")")
        
        filmTitle.text = curFilm.title
        
        filmSubTitle.text = curFilm.overview
        
        filmDate.text = curFilm.release_date
        
    }

    // MARK: -Helper Functions
    private
    func loadPage(urlstring : String){
        guard let urlwithPercentEscapes = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)else { return }
        guard let myURL = URL(string: urlwithPercentEscapes)else { return }
        let myRequest = URLRequest(url: myURL)
        DispatchQueue.main.async {
            self.webView.load( myRequest)
        }
    }

    // MARK: - Subscription Functions
    private
    func backBuAction(){
        BackBu
            .rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe{ [weak self]_ in

                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)

            }.disposed(by: DisposeBags)
    }
    
    private
    func playBuAction(){
        PlayBu
            .rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe{ [weak self]_ in

                guard let self = self else { return }
                self.DrawUPView()
                self.loadPage(urlstring: self.FilmDetailsVM.FilmKey)

            }.disposed(by: DisposeBags)
    }

    private
    func GetKey() {
        guard let Id = curFilm.id else {return}
        Task {
            await FilmDetailsVM.getData(CurFilmID: Id )
        }
    }

    private
    func EnableShowBuSubscription(){
        FilmDetailsVM.EnableBuObservable
            .observe(on: MainScheduler.instance)
            .bind(to: PlayBu.rx.isEnabled).disposed(by: DisposeBags)
        
        FilmDetailsVM.EnableBuObservable
            .observe(on: MainScheduler.instance)
            .bind(to: PlayBu.rx.isHighlighted).disposed(by: DisposeBags)
        
    }

    private
    func ErrorSubscription() {
        FilmDetailsVM.ErrorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] error in

                guard let self = self else { return }
                self.MAK_ShowToast(message: error )
                debugPrint(error)

            }).disposed(by: DisposeBags)
    }
}
