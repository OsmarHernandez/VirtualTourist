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
    
    func selectedPin(in coordinate: CLLocationCoordinate2D)
    
    func updatePinLocation(for coordinate: CLLocationCoordinate2D)
}
