//
//  Pin+Extension.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 07/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import CoreLocation

extension Pin {
    
    var coordinate: CLLocationCoordinate2D {
        let lat = Double(latitude!), long = Double(longitude!)
        return CLLocationCoordinate2D(latitude: lat!, longitude: long!)
    }
    
    public override var description: String {
        return "lat: \(latitude!), long: \(longitude!)"
    }
}
