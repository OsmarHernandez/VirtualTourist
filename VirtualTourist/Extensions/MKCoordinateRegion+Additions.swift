//
//  MKCoordinateRegion+Additions.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 17/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    
    init?(_ dictionary: [String : Any]) {
        guard let center = dictionary["center"] as? [String : Any] else { return nil }
        guard let span = dictionary["span"] as? [String : Any] else { return nil }

        let lat = center["latitude"] as! CLLocationDegrees
        let long = center["longitude"] as! CLLocationDegrees
        
        let latDelt = span["latitudeDelta"] as! CLLocationDistance
        let longDelt = span["longitudeDelta"] as! CLLocationDistance
        
        self.init()
        self.center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.span = MKCoordinateSpan(latitudeDelta: latDelt, longitudeDelta: longDelt)
    }
    
    var description: [String : Any] {
        let desc = [
            "center" : [
                    "latitude" : self.center.latitude,
                    "longitude" : self.center.longitude
            ],
            "span" : [
                    "latitudeDelta" : self.span.latitudeDelta,
                    "longitudeDelta" : self.span.longitudeDelta
            ]
        ]
        
        return desc
    }
}
