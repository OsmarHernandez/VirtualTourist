//
//  Photos.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 20/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct Photos: Codable {
    var page: Int
    var pages: Int
    var perPage: Int
    var total: Int
    var photo: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perPage = "perpage"
        case total = "total"
        case photo = "photo"
    }
}

struct PhotoAlbum: Codable {
    var photos: Photos
    var stat: String
}

struct PhotoStore {
    static var results = [Photo]()
}
