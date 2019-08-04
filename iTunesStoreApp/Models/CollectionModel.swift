//
//  CollectionModel.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import Foundation
import RealmSwift

class CollectionModel: Object {
    
    @objc dynamic var collectionID = 0
    @objc dynamic var collectionName: String?
    @objc dynamic var collectionCensoredName: String?
    @objc dynamic var collectionViewUrl: String?
    @objc dynamic var collectionPrice: Double = 0
    var tracks = List<TrackModel>()
    
    override static func primaryKey() -> String? {
        return "collectionID"
    }
    
    func configure(with data: [String: Any]) {
        self.collectionName = data["collectionName"] as? String ?? EmptyResults.anonymous.rawValue
        self.collectionCensoredName = data["collectionCensoredName"] as? String ?? EmptyResults.anonymous.rawValue
        self.collectionViewUrl = data["collectionViewUrl"] as? String ?? ""
        if let price = data["collectionPrice"] as? Double {
            self.collectionPrice = price
        }
    }
}
