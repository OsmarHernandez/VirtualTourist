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
    
    private func handleRecentPhotosResponse(photos: Photos?, error: Error?) {
        guard let photos = photos else {
            print("Something went wrong: \(error?.localizedDescription ?? "N/A")")
            return
        }
        
        PhotoStore.results = photos.photo
    }
    
    private func loadRecentPhotos(for coordinate: CLLocationCoordinate2D) {
        let params = ["lat" : "\(coordinate.latitude)", "long" : "\(coordinate.longitude)", "extras" : "url_h"]
        let url = FlickrClient.recentPhotosURL(params)
        
        FlickrClient.getPhotos(url, completion: handleRecentPhotosResponse(photos:error:))
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadMapRegion),
                                               name: NSNotification.Name.willEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveMapRegion),
                                               name: NSNotification.Name.didEnterBackground, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? MKAnnotationView else { return }
        
        loadRecentPhotos(for: sender.annotation!.coordinate)
        
        let photoAlbumVC = segue.destination as! PhotoAlbumViewController
        photoAlbumVC.coordinate = sender.annotation?.coordinate
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
