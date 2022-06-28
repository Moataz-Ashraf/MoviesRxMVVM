//
//  FilmTableViewCell.swift
//  RxMVVM
//
//  Created by Moataz on 31/03/2022.
//

import UIKit
import Cosmos

class filmTableViewCell : UITableViewCell {
    deinit{
        print("filmTableViewCell")
    }
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var NameOfFilm: UILabel!
    @IBOutlet weak var StarView: CosmosView!
    @IBOutlet weak var RateLabel: UILabel!
    
    @IBOutlet weak var ContentViewCell: UIView!
    
    var films : Results! {
        didSet{
            let starRate = (((films.vote_average ?? 0.0)/10.0)*5.0)
            
            //let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 90, 0)
//            var transform = CATransform3DIdentity
//               transform.m34 = -1.0 / 500.0
//               transform = CATransform3DRotate(transform, 15 * .pi / 180, 1, 0, 0)
//            ContentViewCell.layer.transform =   transform
            
            backgroundColor = .clear
            ContentViewCell.layer.cornerRadius = 15
            ContentViewCell.backgroundColor = .darkText.withAlphaComponent(0.4)
            
            filmImage.layer.cornerRadius = 15
            
           StarView.rating = Double(starRate)
           StarView.settings.updateOnTouch = false
           StarView.settings.starSize = 20
           
            RateLabel.text = String(format: "%.1f", starRate)
            NameOfFilm.text = films.title
            
            
            filmImage.loadImage(fromURL: "https://image.tmdb.org/t/p/w500\(films.poster_path ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")")
        }
    }
    
    
}
