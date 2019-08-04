//
//  UserModel.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var userID = 0
    @objc dynamic var lastVisited: String?
    var favourites = List<TrackModel>()
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}
