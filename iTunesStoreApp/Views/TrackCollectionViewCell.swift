//
//  DynamicTrackCollectionViewCell.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit
import Alamofire

class TrackCollectionViewCell: UICollectionViewCell, Reusable {
    
    // MARK: - Variables
    var apiManagerDelegate: APIManagerProtocol?
    var databaseMangerDelegate: DatabaseManagerProtocol?
    fileprivate var trackModel: TrackModel?
    
    @IBOutlet weak var containerView: UIView!

    @IBOutlet var shadowedViews: [UIView]!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.containerView.layer.cornerRadius = 15.0
        self.containerView.layer.masksToBounds = true
        
        self.shadowedViews.forEach({
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowRadius = 1.0
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        })
        
        
        self.trackNameLabel.layer.shadowColor = UIColor.black.cgColor
        self.trackNameLabel.layer.shadowRadius = 1.0
        self.trackNameLabel.layer.shadowOpacity = 1.0
        self.trackNameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        self.favouriteButton.setImage(UIImage(named: "track_unfavourite"), for: .normal)
        self.favouriteButton.setImage(UIImage(named: "track_favourite"), for: .selected)
        
        self.artistLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(with trackModel: TrackModel) {
        self.trackModel = trackModel
        
        self.favouriteButton.isSelected = trackModel.isFavourite
        self.trackNameLabel.adjustsFontSizeToFitWidth = true
        
        self.trackNameLabel.text = trackModel.trackName
        self.priceLabel.text = trackModel.trackPriceString
        self.artistLabel.text = trackModel.artistName
        
        if let thumbnailURL = URL(string: trackModel.artworkUrl100) {
            self.apiManagerDelegate?.loadTrackImage(from: thumbnailURL, completed: { image in
                // fade in thumbnail image
                self.thumbnailImageView.image = image
                UIView.animate(withDuration: 0.5, animations: {
                    self.blurView.effect = nil
                })
            })
        }
    }
    
    @IBAction func favouriteButtonTouchedUp(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            DatabaseManager.Instance.addToFavourites(track: self.trackModel!)
        } else {
            DatabaseManager.Instance.deleteFromFavourites(track: self.trackModel!)
        }
        self.databaseMangerDelegate?.didUpdateTrackModels()
    }

    @IBAction func openWebpageTouchedUp(_ sender: UIButton) {
        self.apiManagerDelegate?.loadInMediaPlayer(url: self.trackModel!.previewUrl, description: self.trackModel!.longDescription)
    }
    
    
}
