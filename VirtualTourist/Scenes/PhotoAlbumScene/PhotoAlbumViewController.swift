//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 16/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    
    // MARK: Properties
    var coordinate: CLLocationCoordinate2D!
    let photoAlbumDataSource = PhotoAlbumDataSource()
    
    // MARK: Initial Config
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoAlbumCollectionView.delegate = photoAlbumDataSource
        photoAlbumCollectionView.dataSource = photoAlbumDataSource
        
        mapView.setCenter(coordinate, animated: true)
        addAnnotation(mapView, coordinate: coordinate)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchedPhotosResult), name: NSNotification.Name.fetchedPhotos, object: nil)
    }
    
    @IBAction func newCollectionButtonTapped(_ sender: UIButton) {
        photoAlbumCollectionView.reloadData()
    }
    
    @objc private func fetchedPhotosResult() {
        if PhotoStore.results.count == 0 {
            print("Show messageLabel")
            PhotoStore.results.removeAll()
        }
        
        photoAlbumCollectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PhotoAlbumViewController: MKMapViewDelegate { }