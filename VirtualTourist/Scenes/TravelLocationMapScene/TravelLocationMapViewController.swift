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
    
    private var pin: Pin!
    private var pinList = [Pin]()
    
    private let mapViewDelegate = TravelLocationMapViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewDelegate.pinControlDelegate = self
        mapView.delegate = mapViewDelegate
        
        addNotificationCenter()
        loadMapRegion()
        loadPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mapView.annotations.count > pinList.count {
            print("There are more annotations than there should be, clean screen")
            mapView.removeAnnotations(mapView.annotations)
            loadPins()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    }
    
    @IBAction func longPressOnMapView(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 0.8
        
        let touchPoint = sender.location(in: mapView)
        let coordinate = mapViewDelegate.getCoordinate(forPoin: touchPoint, inMapView: mapView)
        
        if sender.state == .ended {
            DataController.shared.addPin(with: "\(coordinate.latitude)", and: "\(coordinate.longitude)") { createdPin in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: createdPin)
                }
            }
        }
    }
    
    @IBAction func dragButtonTapped(_ sender: UIButton) {
        mapViewDelegate.dragStatus = !mapViewDelegate.dragStatus
        dragStatusLabel.text = mapViewDelegate.dragStatus ? "Drag On" : "Drag Off"
        
        if !mapViewDelegate.dragStatus {
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        }
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveMapRegion),
                                               name: NSNotification.Name.didEnterBackground, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPin = sender as? Pin else  { return }
        
        fetchPhotos(forPin: selectedPin)   // Change if pin has photos
        
        if let photoAlbumVC = segue.destination as? PhotoAlbumViewController {
            photoAlbumVC.pin = selectedPin
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TravelLocationMapViewController {
    
    @objc func saveMapRegion() {
        defaults.set(mapView.region.description, forKey: Constants.mapRegion)
    }
    
    private func loadMapRegion() {
        if let region = mapViewDelegate.region {
            mapView.region = region
        }
    }
    
    private func loadPins() {
        DataController.shared.loadPins() { pins in
            self.pinList = pins
            DispatchQueue.main.async {
                self.mapViewDelegate.drawPins(self.pinList, inMapView: self.mapView)
            }
        }
    }
    
    private func fetchPhotos(forPin pin: Pin) {
        let additionalParams = [
            "lat" : pin.latitude!,
            "lon" : pin.longitude!,
            "per_page" : "20",
            "extras" : "url_h"
        ]
        
        FlickrClient.getPhotos(additionalParams) { (photos, error) in
            PhotoStore.results = photos?.photo ?? []
            NotificationCenter.default.post(name: NSNotification.Name.fetchedPhotos, object: nil)
        }
    }
    
    private func selectPin(_ latitude: String, _ longitude: String) {
        DataController.shared.getPin(for: latitude, and: longitude) { currentPin in
            if let currentPin = currentPin {
                self.performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: currentPin)
            }
        }
    }
    
    private func updatePin(_ latitude: String, _ longitude: String) {
        if let _ = pin {
            DataController.shared.updatePin(pin, with: latitude, and: longitude) { newPin in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: newPin)
                }
            }
        }
    }
}

extension TravelLocationMapViewController: PinControlDelegate {
    
    func selectedPin(inCoordinate coordinate: CLLocationCoordinate2D) {
        if mapViewDelegate.dragStatus {
            DataController.shared.getPin(for: "\(coordinate.latitude)", and: "\(coordinate.longitude)") { currentPin in
                if let currentPin = currentPin {
                    self.pin = currentPin
                }
            }
        } else {
            selectPin("\(coordinate.latitude)", "\(coordinate.longitude)")
        }
    }
    
    func updatePinLocation(forNewCoordinate coordinate: CLLocationCoordinate2D) {
        updatePin("\(coordinate.latitude)", "\(coordinate.longitude)")
    }
}
