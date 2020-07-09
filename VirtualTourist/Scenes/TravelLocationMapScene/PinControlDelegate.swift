//
//  PinControlDelegate.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 08/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import CoreLocation

protocol PinControlDelegate: class {
    
    func selectedPin(inCoordinate coordinate: CLLocationCoordinate2D)
    
    func updatePinLocation(forNewCoordinate coordinate: CLLocationCoordinate2D)
}
