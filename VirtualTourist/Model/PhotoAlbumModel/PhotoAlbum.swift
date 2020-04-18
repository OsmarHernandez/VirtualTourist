//
//  PhotoAlbum.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 17/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

struct PhotoAlbum {
    var photos: [UIImage]
    
    init() {
        self.photos = []
    }
}

class PhotoAlbumStore {
    var photoAlbums: [PhotoAlbum]
    
    init() {
        self.photoAlbums = []
    }
}
