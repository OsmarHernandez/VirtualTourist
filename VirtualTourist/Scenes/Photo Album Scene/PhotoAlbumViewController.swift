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
    }
    
    @IBAction func newCollectionButtonTapped(_ sender: UIButton) {
        print("Reload Data?")
        photoAlbumCollectionView.reloadData()
    }
}

extension PhotoAlbumViewController: MKMapViewDelegate { }
