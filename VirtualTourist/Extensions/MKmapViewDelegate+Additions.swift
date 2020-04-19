//
//  MKmapViewDelegate+Additions.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 18/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import MapKit

extension MKMapViewDelegate {
    func addAnnotation(_ mapView: MKMapView, point: CGPoint? = nil, coordinate: CLLocationCoordinate2D? = nil) {
        var coordinate = coordinate
        
        if let point = point {
            coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        
        mapView.addAnnotation(annotation)
    }
}
