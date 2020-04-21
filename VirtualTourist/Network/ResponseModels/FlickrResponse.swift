//
//  FlickrResponse.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 21/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct FlickrResponse: Decodable {
    var photos: PhotosResponse
    var stat: String
}
