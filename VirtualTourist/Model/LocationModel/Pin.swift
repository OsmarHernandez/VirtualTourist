//
//  Location.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 17/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

struct Pin {
    var latitude: CGFloat
    var longitude: CGFloat
    
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
    
    var photos: [PhotoResponse]? = nil
}

class PinStore {
    static let shared = PinStore()
    
    var pins: [Pin]
    
    private init() {
        self.pins = []
    }
    
    func loadPin(_ latitude: CGFloat, _ longitude: CGFloat) -> Pin? {
        var pin: Pin?
        
        for currentPin in pins {
            if currentPin.latitude == latitude && currentPin.longitude == longitude {
                pin = currentPin
            }
        }
        
        return pin
    }
    
    func addPin(_ pin: Pin) {
        self.pins.append(pin)
    }
    
    var total: Int {
        return pins.count
    }
}
