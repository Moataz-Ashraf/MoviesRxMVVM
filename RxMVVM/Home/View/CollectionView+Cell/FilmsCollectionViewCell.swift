//
//  HomeTableViewCell.swift
//  RxMVVM
//
//  Created by Moataz on 04/01/2022.
//




import UIKit
import Cosmos

class filmsCollectionViewCell: UICollectionViewCell {
    deinit{
        print("filmsCollectionViewCell")
    }
    @IBOutlet weak var FilmImage: UIImageView!
    @IBOutlet weak var FilmTitle: UILabel!
    
    @IBOutlet weak var StarView: CosmosView!
    
    var withBackView : Bool! {
        didSet {
            self.backViewGenrator()
        }
    }
    
    private lazy var backView: UIImageView = {
        let backView = UIImageView(frame: FilmImage.frame)
        backView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: FilmImage.topAnchor),
            backView.leadingAnchor.constraint(equalTo: FilmImage.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: FilmImage.trailingAnchor, constant: 20),
            backView.bottomAnchor.constraint(equalTo: FilmImage.bottomAnchor, constant: 20)
        ])
        backView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        backView.alpha = 0.5
        contentView.bringSubviewToFront(FilmImage)
        return backView
    }()

    var films : Results! {
        didSet{
            let starRate = (((films.vote_average ?? 0.00)/10.00)*5.00)
            
            StarView.rating = Double(starRate)
            StarView.settings.updateOnTouch = false
            StarView.settings.starSize = 20
            
            FilmTitle.text = films.title
            FilmImage.loadImage(fromURL: "https://image.tmdb.org/t/p/w500\(films.poster_path ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")")
        }
    }
    
    private
    func backViewGenrator(){
        backView.loadImage(fromURL: "https://image.tmdb.org/t/p/w500\(films.poster_path ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")")
    }
    
    override
    func prepareForReuse() {
        
        FilmImage.image = UIImage()
        backView.image = UIImage()
        FilmTitle.text = ""
        StarView.rating = 0
        
    }
    
}
    
