//
//  TravelLocationMapViewDelegate.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 08/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import MapKit

class TravelLocationMapViewDelegate: NSObject, MKMapViewDelegate {
    
    var dragStatus = false
    
    weak var pinControlDelegate: PinControlDelegate!
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.locationPin) as? MKMarkerAnnotationView
        
        markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.locationPin)
        
        return markerView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.isDraggable = dragStatus
        
        pinControlDelegate.selectedPin(inCoordinate: view.annotation!.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            pinControlDelegate.updatePinLocation(forNewCoordinate: view.annotation!.coordinate)
        }
        
        view.isDraggable = false
    }
}

extension TravelLocationMapViewDelegate {
    
    var region: MKCoordinateRegion? {
        guard let dictionary = defaults.value(forKey: Constants.mapRegion) as? [String : Any] else { return nil }
        return MKCoordinateRegion(dictionary)
    }
    
    func getCoordinate(forPoin point: CGPoint, inMapView mapView: MKMapView) -> CLLocationCoordinate2D {
        return addAnnotation(mapView, point: point)
    }
    
    func drawPins(_ pins: [Pin], inMapView mapView: MKMapView) {
        for pin in pins {
            addAnnotation(mapView, coordinate: pin.coordinate)
        }
    }
}
