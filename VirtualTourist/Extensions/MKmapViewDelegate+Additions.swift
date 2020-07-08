//
//  MKmapViewDelegate+Additions.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 18/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import MapKit

extension MKMapViewDelegate {
    
    /*
     * use the function with the coordinate argument to draw an existing pin
     * use the functuin wiht the point argument to draw for first time
     */
    @discardableResult func addAnnotation(_ mapView: MKMapView, point: CGPoint? = nil, coordinate: CLLocationCoordinate2D? = nil) -> CLLocationCoordinate2D  {
        var coordinate = coordinate
        
        if let point = point {
            coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        
        mapView.addAnnotation(annotation)
        
        return annotation.coordinate
    }
}
