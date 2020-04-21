//
//  TravelLocationMapViewController.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 16/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import MapKit

class TravelLocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dragStatusLabel: UILabel!
    
    private var dragStatus: Bool!
    
    private var region: MKCoordinateRegion? {
        guard let dictionary = defaults.value(forKey: Constants.mapRegion) as? [String : Any] else { return nil }
        return MKCoordinateRegion(dictionary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragStatus = false
        addNotificationCenter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    }
    
    @IBAction func longPressOnMapView(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 0.8
        
        if sender.state == .began {
            let touchPoint = sender.location(in: mapView)
            addAnnotation(mapView, point: touchPoint)
        } else if sender.state == .ended {
            print("Ended")
        }
    }
    
    @IBAction func dragButtonTapped(_ sender: UIButton) {
        dragStatus = !dragStatus
        dragStatusLabel.text = dragStatus ? "Drag On" : "Drag Off"
        
        if !dragStatus {
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        }
    }
    
    @objc func loadMapRegion() {
        if let region = region {
            mapView.region = region
        }
    }
    
    @objc func saveMapRegion() {
        defaults.set(mapView.region.description, forKey: Constants.mapRegion)
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadMapRegion),
                                               name: NSNotification.Name.willEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveMapRegion),
                                               name: NSNotification.Name.didEnterBackground, object: nil)
    }
    
    private func fetchPhotos(from coordinate: CLLocationCoordinate2D) {
        let additionalParams = [
            "lat" : "\(coordinate.latitude)",
            "lon" : "\(coordinate.longitude)",
            "per_page" : "20",
            "extras" : "url_h"
        ]
        
        FlickrClient.getPhotos(additionalParams) { (photos, error) in
            if let photos = photos {
                PhotoStore.results = photos.photo
            } else {
                PhotoStore.results = []
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.fetchedPhotos, object: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? MKAnnotationView,
            let coordinate = sender.annotation?.coordinate else { return }
        
        fetchPhotos(from: coordinate)
        
        if let photoAlbumVC = segue.destination as? PhotoAlbumViewController {
            photoAlbumVC.coordinate = coordinate
        }
    }
    
    // TODO: Persist Pins
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TravelLocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.locationPin) as? MKMarkerAnnotationView
        
        if markerView == nil {
            markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.locationPin)
        } else {
            markerView!.annotation = annotation
        }
        
        return markerView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if dragStatus {
            view.isDraggable = true
        } else {
            performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: view)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: view)
        }
    }
}
