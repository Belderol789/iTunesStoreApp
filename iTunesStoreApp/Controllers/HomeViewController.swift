//
//  ViewController.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit
import AVKit

class HomeViewController: SafariBasedViewController {
    
    // MARK: - Variables
    fileprivate let apiManager: APIManager = APIManager()
    fileprivate var trackCollections: [[String: [TrackModel]]] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var kindSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentTableView: UITableView! {
        didSet {
            contentTableView.register(TrackSectionsTableViewCell.nib, forCellReuseIdentifier: TrackSectionsTableViewCell.className)
            contentTableView.delegate = self
            contentTableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show loading
        apiManager.loadJSONData { success in
            if success {
                self.trackCollections = ContentManager.Instance.retrieveTrackSectionedObject()
                self.contentTableView.reloadData()
            } else {
                // show empty state view/ loading view
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.trackCollections = ContentManager.Instance.retrieveFilteredTrackSectionObjects(with: .song)
        case 2:
            self.trackCollections = ContentManager.Instance.retrieveFilteredTrackSectionObjects(with: .featureMovie)
        case 3:
            self.trackCollections = ContentManager.Instance.retrieveFilteredTrackSectionObjects(with: .tvEpisode)
        case 4:
            self.trackCollections = ContentManager.Instance.retrieveFilteredTrackSectionObjects(with: .podcast)
        default:
            // all tracks
            self.trackCollections = ContentManager.Instance.retrieveTrackSectionedObject()
            
        }
        self.contentTableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? self.view.frame.height / 5 : self.view.frame.height / 3
        return cellHeight
    }
    
}
// MARK: - UITableviewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackCollections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackSectionsTableViewCell.className, for: indexPath) as? TrackSectionsTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(with: self.trackCollections[indexPath.row])
        return cell
    }
}

// MARK: APIManagerProtocol
extension HomeViewController: APIManagerProtocol {
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

    func loadTrackImage(from url: URL, completed: @escaping (UIImage) -> Void) {
        self.apiManager.loadTrackImage(from: url) { (image) in
            completed(image)
        }
    }
    
}

