//
//  PhotosResponse.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 21/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct PhotosResponse: Decodable {
    var page: Int
    var pages: Int
    var perPage: Int
    var total: String
    var photo: [PhotoResponse]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perPage = "perpage"
        case total = "total"
        case photo = "photo"
    }
}
