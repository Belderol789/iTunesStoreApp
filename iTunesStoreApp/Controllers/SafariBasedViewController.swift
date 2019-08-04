//
//  SafariBasedViewController.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit
import SafariServices
import AVKit

class SafariBasedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func openInSafari(with urlStrimg: String) {
        guard let url = URL(string: urlStrimg) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    
    func showPreview(with url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

}
