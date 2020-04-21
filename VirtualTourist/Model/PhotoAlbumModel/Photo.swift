//
//  Photo.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 20/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var isPublic: Int
    var isFriend: Int
    var isFamily: Int
    var urlH: String?
    var heightH: Int?
    var widthH: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case owner = "owner"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
        case title = "title"
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
        case urlH = "url_h"
        case heightH = "height_h"
        case widthH = "width_h"
    }
}
