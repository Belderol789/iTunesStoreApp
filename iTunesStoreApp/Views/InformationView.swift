//
//  InformationView.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit
import AVKit

class InformationView: UIView {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var trackDescriptionLabel: UILabel!
    // Constraints
    @IBOutlet weak var mediaViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var mediaViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaViewLeadingConstraint: NSLayoutConstraint!
    
    fileprivate var mediaViewMargins: CGFloat {
        get {
            return mediaViewTrailingConstraint.constant + mediaViewLeadingConstraint.constant
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.masksToBounds = true
        self.trackDescriptionLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func configure(with description: String, previewURL: URL) {
        self.trackDescriptionLabel.text = description
        let player = AVPlayer(url: previewURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.mediaView.frame.width - mediaViewMargins, height: self.mediaViewHeightConstraints.constant)
        self.mediaView.layer.addSublayer(playerLayer)
        player.play()
    }

    // MARK: - IBActions
    @IBAction func dismissButtonTouchedUp(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
