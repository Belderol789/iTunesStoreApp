//
//  ExtensionsManager.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var className: String { get }
    static var nib: UINib { get }
}

extension Reusable {
    
    static var className: String {
        return "\(self)"
    }
    
    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
}
