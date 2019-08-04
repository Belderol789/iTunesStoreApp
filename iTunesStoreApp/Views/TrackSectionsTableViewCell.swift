//
//  TrackCollectionTableViewCell.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit

class TrackSectionsTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Variables
    @IBOutlet weak var trackSectionLabel: UILabel!
    @IBOutlet weak var trackCollectionView: UICollectionView!
    
    var delegate: APIManagerProtocol?
    var hideFavourite: Bool = false
    
    fileprivate var trackModels: [TrackModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.trackCollectionView.backgroundColor = .clear
        self.trackCollectionView.register(TrackCollectionViewCell.nib, forCellWithReuseIdentifier: TrackCollectionViewCell.className)
        self.trackCollectionView.delegate = self
        self.trackCollectionView.dataSource = self
    }
    
    func configure(with trackModels: [String: [TrackModel]]) {
        self.trackModels = Array(trackModels.values.first ?? [])
        self.trackSectionLabel.text = trackModels.keys.first
        self.trackCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewFlowDelegate
extension TrackSectionsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad  ? collectionView.frame.width/4.25 : collectionView.frame.width/2.5
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
}
// MARK: - UICollectionViewDataSource
extension TrackSectionsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trackModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.className, for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.apiManagerDelegate = self
        cell.configure(with: self.trackModels[indexPath.item])
        cell.favouriteButton.isHidden = self.hideFavourite
        return cell
    }
}

// MARK: - APIManagerProtocol
extension TrackSectionsTableViewCell: APIManagerProtocol {
    func loadInMediaPlayer(url: String, description: String) {
        self.delegate?.loadInMediaPlayer(url: url, description: description)
    }

    func loadTrackImage(from url: URL, completed: @escaping (UIImage) -> Void) {
        self.delegate?.loadTrackImage(from: url, completed: { (image) in
            completed(image)
        })
    }

}
