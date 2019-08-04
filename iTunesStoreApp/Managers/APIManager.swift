//
//  APIManager.swift
//  iTunesStoreApp
//
//  Created by Kem Belderol on 04/08/2019.
//  Copyright © 2019 Krats. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

protocol APIManagerProtocol {
    func loadTrackImage(from url: URL, completed: @escaping (UIImage) -> Void)
    func loadInMediaPlayer(url: String, description: String)
}


class APIManager: NSObject {
    
    // MARK: - Variables
    var delegate: APIManagerProtocol?
    fileprivate let apiURL: String = "https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie&amp;all"

    // MARK: - API CALL: Load Data
    func loadJSONData(success: @escaping (Bool) -> Void) {
        Alamofire.request(self.apiURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            guard let result = response.result.value as? [String: Any] else {
                success(false)
                return
            }
            
            if let resultObjects = result["results"] as? [[String: Any]] {
                for object in resultObjects {

                    let trackModel = TrackModel()
                    trackModel.configure(with: object)
                    
                    ContentManager.Instance.saveTrackModel(with: trackModel)
                    ContentManager.Instance.saveAllGenres(with: trackModel.primaryGenreName)

                    let collectionModel = CollectionModel()
                    collectionModel.configure(with: object)
                    
                    ContentManager.Instance.saveCollectionModel(with: collectionModel)
                }
                success(true)
            }
        }
    }
    
    func loadTrackImage(from url: URL, completed: @escaping (UIImage) -> Void) {
        Alamofire.request(url).responseData { response in
            if let imageData = response.result.value {
                guard let image = UIImage(data: imageData) else {return}
                completed(image)
            }
        }
    }
}
