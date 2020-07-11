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
        
        print("3: Updated pin photos: \(String(describing: selectedPin.hasPhotos))")
        
        if selectedPin.hasPhotos {
            print("Using results from Core Data")
        } else {
            print("Downloading data for Photos")
            self.fetchPhotos(for: selectedPin)
        }
        
        if let photoAlbumVC = segue.destination as? PhotoAlbumViewController {
            print("Photos with pin for segue: \(selectedPin.photo?.count ?? 0)")
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
    
    private func selectPin(_ latitude: String, _ longitude: String) {
        DataController.shared.getPin(for: latitude, and: longitude) { currentPin in
            guard let currentPin = currentPin else { return }
            
            if self.mapViewDelegate.dragStatus {
                self.pin = currentPin
                print("1: Updated pin photos: \(String(describing: self.pin.hasPhotos))")
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: currentPin)
                }
            }
        }
    }
    
    private func updatePin(_ latitude: String, _ longitude: String) {
        if let _ = pin {
            DataController.shared.updatePin(pin, with: latitude, and: longitude) { newPin in
                DispatchQueue.main.async {
                    print("2: Updated pin photos: \(String(describing: newPin.hasPhotos))")
                    self.performSegue(withIdentifier: Constants.photoAlbumSegueIdentifier, sender: newPin)
                }
            }
        }
    }
}

extension TravelLocationMapViewController: PinControlDelegate {
    
    func selectedPin(in coordinate: CLLocationCoordinate2D) {
        selectPin("\(coordinate.latitude)", "\(coordinate.longitude)")
    }
    
    func updatePinLocation(for coordinate: CLLocationCoordinate2D) {
        updatePin("\(coordinate.latitude)", "\(coordinate.longitude)")
    }
}
