//
//  FavouritesViewController.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit
import AVKit

class FavouritesViewController: SafariBasedViewController {

    // MARK: -Variables
    fileprivate var favouriteTracks: [TrackModel] = []
    let apiManager: APIManager = APIManager()
    // MARK: - IBOutlets
    @IBOutlet weak var favouritesCollectionView: UICollectionView! {
        didSet {
            favouritesCollectionView.backgroundColor = .clear
            favouritesCollectionView.register(TrackCollectionViewCell.nib, forCellWithReuseIdentifier: TrackCollectionViewCell.className)
            favouritesCollectionView.delegate = self
            favouritesCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var emptyStateView: EmptyStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.retrieveFavourites()
    }
    
    fileprivate func retrieveFavourites() {
        self.favouriteTracks = DatabaseManager.Instance.retrieveAllFavourites()
        self.configureEmptyStateView()
        self.favouritesCollectionView.reloadData()
    }
    
    fileprivate func configureEmptyStateView() {
        self.emptyStateView.configure(with: "You don't have any Favourites.")
        self.emptyStateView.isHidden = !self.favouriteTracks.isEmpty
        self.emptyStateView.emptyImageView.tintColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        if self.favouriteTracks.isEmpty {
            self.view.bringSubviewToFront(self.emptyStateView)
        } else {
            self.view.sendSubviewToBack(self.emptyStateView)
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad  ? collectionView.frame.width/4 : collectionView.frame.width/2
        return CGSize(width: cellWidth, height: collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
}
// MARK: - UICollectionViewDataSource
extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favouriteTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.className, for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.databaseMangerDelegate = self
        cell.apiManagerDelegate = self
        cell.configure(with: self.favouriteTracks[indexPath.item])
        cell.favouriteButton.isUserInteractionEnabled = false
        return cell
    }
    
}
// MARK: - APIManagerProtocol {
extension FavouritesViewController: APIManagerProtocol {
    func loadInMediaPlayer(url: String, description: String) {
        guard let previewUrl = URL(string: url) else {return}
        if description == "" {
            self.showPreview(with: previewUrl)
        } else {
            let infoView = UINib(nibName: "InformationView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? InformationView
            infoView?.frame = self.view.frame
            infoView?.configure(with: description, previewURL: previewUrl)
            self.view.addSubview(infoView!)
        }
    }
    
    func loadInSafari(url: String) {
        self.openInSafari(with: url)
    }

    func loadTrackImage(from url: URL, completed: @escaping (UIImage) -> Void) {
        self.apiManager.loadTrackImage(from: url) { image in
            completed(image)
        }
    }
}
// MARK: - DatabaseManagerProtocol
extension FavouritesViewController: DatabaseManagerProtocol {
    func didUpdateTrackModels() {
        self.retrieveFavourites()
    }
    
}
