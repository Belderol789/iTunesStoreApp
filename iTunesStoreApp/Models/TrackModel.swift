//
//  TrackModel.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import Foundation
import RealmSwift

enum EmptyResults: String {
    case anonymous = "Anonymous"
    case unavailable = "Unavailable"
}

enum TrackTypes: String {
    case song = "song"
    case featureMovie = "feature-movie"
    case tvEpisode = "tv-episode"
}

class TrackModel: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var trackId: Int = 0
    @objc dynamic var kind: String = ""
    @objc dynamic var artistName: String = ""
    @objc dynamic var collectionName: String = ""
    @objc dynamic var trackName: String = ""
    @objc dynamic var trackPrice: Double = 0
    @objc dynamic var currency: String = ""
    @objc dynamic var trackViewUrl: String = ""
    @objc dynamic var artistViewUrl: String = ""
    @objc dynamic var previewUrl: String = ""
    @objc dynamic var artworkUrl100: String = ""
    @objc dynamic var primaryGenreName: String = ""
    @objc dynamic var isFavourite: Bool = false
    
    var trackPriceString: String {
        get {
            let priceString: String = (trackPrice == 0) ? "Free" : "\(trackPrice) \(currency)"
            return priceString
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func configure(with data: [String: Any]) {
        self.id = UUID().uuidString
        self.trackId = data["trackId"] as? Int ?? 0
        self.kind = data["kind"] as? String ?? "na"
        self.artistName = data["artistName"] as? String ?? EmptyResults.anonymous.rawValue
        self.trackName = data["trackName"] as? String ?? EmptyResults.anonymous.rawValue
        self.collectionName = data["collectionName"] as? String ?? EmptyResults.unavailable.rawValue
        self.primaryGenreName = data["primaryGenreName"] as? String ?? EmptyResults.unavailable.rawValue
        self.currency = data["currency"] as? String ?? EmptyResults.unavailable.rawValue
        self.artworkUrl100 = data["artworkUrl100"] as? String ?? ""
        self.artistViewUrl = data["artistViewUrl"] as? String ?? ""
        self.previewUrl = data["previewUrl"] as? String ?? ""
        self.trackViewUrl = data["trackViewUrl"] as? String ?? ""
        
        self.isFavourite = DatabaseManager.Instance.checkIfTrackIsFavourite(with: self.trackId)
        
        if let price = data["trackPrice"] as? Double {
            self.trackPrice = price
        }
    }
}
