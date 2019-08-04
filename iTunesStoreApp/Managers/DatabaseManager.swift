//
//  DatabaseManager.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import Foundation
import RealmSwift

protocol DatabaseManagerProtocol {
    func didUpdateTrackModels()
}

class DatabaseManager: NSObject {
    
    private static let _instance = DatabaseManager()
    static var Instance: DatabaseManager {
        return _instance
    }
    
    var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch {
                print("Could not access database: ", error)
            }
            return self.realm
        }
    }
    
    var allTracks: Results<TrackModel> {
        get {
            return realm.objects(TrackModel.self)
        }
    }
    
    func retrieveAllFavourites() -> [TrackModel] {
        let favouriteTracks = allTracks.filter({$0.isFavourite == true})
        return Array(favouriteTracks)
    }

    // only persiste favourited tracks
    func addToFavourites(track: TrackModel) {
        do {
            try self.realm.write {
                track.isFavourite = true
                self.realm.add(track)
            }
        } catch {
            
        }
    }
    
    func deleteFromFavourites(track: TrackModel) {
        do {
            try self.realm.write {
                track.isFavourite = false
            }
        } catch {
            print("Delete Failed")
        }
    }
    
    func checkIfTrackIsFavourite(with trackId: Int) -> Bool {
        return self.allTracks.filter({$0.trackId == trackId}).first?.isFavourite ?? false
    }
    
}
