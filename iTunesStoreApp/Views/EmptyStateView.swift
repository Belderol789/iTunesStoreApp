//
//  EmptyStateView.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    // MARK: - Variables
    fileprivate let identifier: String = "EmptyStateView"
    // MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initXibs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initXibs()
    }
    
    
    fileprivate func initXibs() {
        Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    func configure(with text: String) {
        self.emptyLabel.text = text
    }

}
