//
//  ContentManager.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import Foundation

enum TrackKinds: String {
    case song = "song"
    case featureMovie = "feature-movie"
    case tvEpisode = "tv-episode"
    case podcast = "podcast"
}

class ContentManager: NSObject {
    
    private static let _instance = ContentManager()
    static var Instance: ContentManager {
        return _instance
    }
    
    fileprivate var trackModels: [TrackModel] = []
    fileprivate var collectionModels: [CollectionModel] = []
    fileprivate var favouriteTrackModels: [TrackModel] = []
    fileprivate var genres: [String] = []
    
    func saveTrackModel(with track: TrackModel) {
        let trackIDs = self.trackModels.map({$0.trackId})
        if trackIDs.contains(track.trackId) == false {
          self.trackModels.append(track)
        }
    }
    
    func saveCollectionModel(with collection: CollectionModel) {
        let collectionModelNames = self.collectionModels.map({$0.collectionName!})
        if collectionModelNames.contains(collection.collectionName!) == false {
           self.collectionModels.append(collection)
        }
    }
    
    func saveAllGenres(with genre: String) {
        if self.genres.contains(genre) == false {
          self.genres.append(genre)
        }
    }
    
    func retrieveAllTrackModels() -> [TrackModel] {
        return trackModels
    }
    
    func retrieveAllCollections() -> [CollectionModel] {
        return collectionModels
    }
    
    func retrieveAllFavouriteTracks() -> [TrackModel] {
       let favouriteTracks = DatabaseManager.Instance.allTracks.filter({
            $0.isFavourite == true
       })
        return Array(favouriteTracks)
    }
    
    func retrieveCollectionSectionedObjects() -> [[String: [TrackModel]]] {
        var collectionObjects: [[String: [TrackModel]]] = []
        for collection in self.collectionModels {
            let collectionTracks: [TrackModel] = self.trackModels.filter({$0.collectionName == collection.collectionName!})
            let collectionObject: [String: [TrackModel]] = [collection.collectionName!: collectionTracks]
            if !collectionTracks.isEmpty {
                collectionObjects.append(collectionObject)
            }
        }
        return collectionObjects
    }
    
    func retrieveTrackSectionedObject() -> [[String: [TrackModel]]] {
        // Place tracks into their sections
        var trackCollection: [[String: [TrackModel]]] = []
        for genre in self.genres {
            if let trackingGenreObject = self.filterTrack(models: self.trackModels, genre: genre) {
                trackCollection.append(trackingGenreObject)
            }
        }
        return trackCollection
    }
    
    func retrieveFilteredTrackSectionObjects(with kind: TrackKinds) -> [[String: [TrackModel]]] {
        // get tracks with partcular type
        var trackSongsCollection: [[String: [TrackModel]]] = []
        for genre in self.genres {
            let trackingTypes = self.trackModels.filter({$0.kind == kind.rawValue})
            if let trackingTypeObjects = self.filterTrack(models: trackingTypes, genre: genre) {
               trackSongsCollection.append(trackingTypeObjects)
            }
        }
        return trackSongsCollection
    }
    
    fileprivate func filterTrack(models: [TrackModel], genre: String) -> [String: [TrackModel]]?  {
        let filteredModels = models.filter({$0.primaryGenreName == genre}).sorted(by: { $0.trackName < $1.trackName })
        if filteredModels.isEmpty {
            return nil
        }
        let trackCollectionObject: [String: [TrackModel]] = [genre: filteredModels]
        return trackCollectionObject
    }
    
}
