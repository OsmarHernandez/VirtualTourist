//
//  Location.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 17/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

struct Location {
    fileprivate var latitude: CGFloat
    fileprivate var longitude: CGFloat
    
    init(lat: CGFloat, long: CGFloat) {
        self.latitude = lat
        self.longitude = long
    }
    
    var lat: String {
        return "\(latitude)"
    }
    
    var long: String {
        return "\(longitude)"
    }
}

class LocationStore {
    var locations: [Location]
    
    init() {
        self.locations = []
    }
}
