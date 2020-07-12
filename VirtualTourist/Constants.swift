//
//  Constants.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 17/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

var defaults: UserDefaults {
    return UserDefaults.standard
}

struct Constants {
    static let mapRegion = "Map.Region"
    static let locationPin = "locationPin"
    static let photoAlbumSegueIdentifier = "PhotoAlbumSceneSegue"
    
    static let photoCellIdentifier = "PhotoAlbumViewCell"
    
    static var pages: Int = 1
    
    static var additionalParameters: (String, String) -> [String : String] = { latitude, longitude in
        let page = Int.random(in: 1...pages)
        
        return [
            "lat" : latitude,
            "lon" : longitude,
            "per_page" : "20",
            "extras" : "url_h",
            "page" : "\(page)"
        ]
    }
}
