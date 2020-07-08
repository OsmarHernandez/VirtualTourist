//
//  TravelLocationMapViewController.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 16/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import MapKit
import CoreData

class TravelLocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dragStatusLabel: UILabel!
    
    private var dragStatus = false
    
    private var pin: Pin!
    private var pinList = [Pin]()
    
    var dataController: DataController!
    
    private var region: MKCoordinateRegion? {
        guard let dictionary = defaults.value(forKey: Constants.mapRegion) as? [String : Any] else { return nil }
        return MKCoordinateRegion(dictionary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationCenter()
        reloadPins()
        loadMapRegion()
        
        drawPins()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    }
    
    @IBAction func longPressOnMapView(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 0.8
        
        let touchPoint = sender.location(in: mapView)
        let coordinate = addAnnotation(mapView, point: touchPoint)
        
        if sender.state == .ended {
            let pin = Pin(context: dataController.viewContext)
            pin.latitude = "\(coordinate.latitude)"
            pin.longitude = "\(coordinate.longitude)"
            try? dataController.viewContext.save()
        }
    }
    
    @IBAction func dragButtonTapped(_ sender: UIButton) {
        dragStatus = !dragStatus
        dragStatusLabel.text = dragStatus ? "Drag On" : "Drag Off"
        
        if !dragStatus {
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        }
    }
    
    @objc func saveMapRegion() {
        defaults.set(mapView.region.description, forKey: Constants.mapRegion)
    }
    
    private func reloadPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            pinList = result
        }
    }
    
    private func drawPins() {
        for pin in pinList {
            addAnnotation(mapView, coordinate: pin.coordinate)
        }
    }
    
    private func loadMapRegion() {
        if let region = region {
            mapView.region = region
        }
    }
    
    private func addNotificationCenter() {
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
            PhotoStore.results = photos?.photo ?? []
            //self.pin.photos = photos?.photo
            
            // save context
            
            NotificationCenter.default.post(name: NSNotification.Name.fetchedPhotos, object: nil)
        }
    }
    
    private func pin(_ latitude: String, _ longitude: String) -> Pin? {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude == %@ && longitude == %@", latitude, longitude)
        fetchRequest.predicate = predicate
        
        let result = try! dataController.viewContext.fetch(fetchRequest)
        return result.first
    }
    
    private func pinForCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let lat = "\(coordinate.latitude)"
        let long = "\(coordinate.longitude)"
        
        if let currentPin = pin(lat, long) {
            pin = currentPin
            performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: coordinate)
        }
    }
    
    private func updatePinWithCoordinate(_ coordinate: CLLocationCoordinate2D) {
        if let oldPin = pin(pin.latitude!, pin.longitude!) {
            oldPin.latitude = "\(coordinate.latitude)"
            oldPin.longitude = "\(coordinate.longitude)"
            try? dataController.viewContext.save()
            performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: coordinate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let coordinate = sender as? CLLocationCoordinate2D else  { return }
        
        fetchPhotos(from: coordinate)   // Change if pin has photos
        
        if let photoAlbumVC = segue.destination as? PhotoAlbumViewController {
            photoAlbumVC.pin = pin
        }
    }
    
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
            
            let latitude = "\(view.annotation!.coordinate.latitude)"
            let longitude = "\(view.annotation!.coordinate.longitude)"
            
            pin = pin(latitude, longitude)
        } else {
            pinForCoordinate(view.annotation!.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        view.isDraggable = false
        
        if newState == .ending {
            updatePinWithCoordinate(view.annotation!.coordinate)
        }
    }
}
