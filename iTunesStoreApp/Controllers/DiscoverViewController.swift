//
//  DiscoverViewController.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit
import AVKit

class DiscoverViewController: SafariBasedViewController {
    // MARK: - Variables
    fileprivate let apiManager: APIManager = APIManager()
    fileprivate var discoverObjects: [[String: [TrackModel]]] = []
    // MARK: - IBOutlets
    @IBOutlet weak var discoverTableView: UITableView! {
        didSet {
            discoverTableView.register(TrackSectionsTableViewCell.nib, forCellReuseIdentifier: TrackSectionsTableViewCell.className)
            discoverTableView.delegate = self
            discoverTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.discoverObjects = ContentManager.Instance.retrieveCollectionSectionedObjects()
        self.discoverTableView.reloadData()

    }
}
// MARK: APIManagerProtocol
extension DiscoverViewController: APIManagerProtocol {
    func loadInSafari(url: String) {
        self.openInSafari(with: url)
    }
    
    func loadInMediaPlayer(url: String) {
        guard let url = URL(string: url) else {return}
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    
    
    func loadTrackImage(from url: URL, completed: @escaping (UIImage) -> Void) {
        self.apiManager.loadTrackImage(from: url) { (image) in
            completed(image)
        }
    }
}

// MARK: - UITableViewDelegate
extension DiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? self.view.frame.height / 5 : self.view.frame.height / 3
        return cellHeight
    }
}
// MARK: - UITableViewDatasource
extension DiscoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discoverObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackSectionsTableViewCell.className, for: indexPath) as? TrackSectionsTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.hideFavourite = true
        cell.configure(with: self.discoverObjects[indexPath.row])
        return cell
    }
}

