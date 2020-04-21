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
}
