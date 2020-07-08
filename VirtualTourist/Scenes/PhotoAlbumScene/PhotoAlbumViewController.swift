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
    @IBOutlet weak var messageLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    var pin: Pin!
    let photoAlbumDataSource = PhotoAlbumDataSource()
    
    // MARK: Initial Config
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoAlbumCollectionView.delegate = photoAlbumDataSource
        photoAlbumCollectionView.dataSource = photoAlbumDataSource
        
        mapView.setCenter(pin.coordinate, animated: true)
        addAnnotation(mapView, coordinate: pin.coordinate)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchedPhotosResult), name: NSNotification.Name.fetchedPhotos, object: nil)
    }
    
    @IBAction func newCollectionButtonTapped(_ sender: UIButton) {
        photoAlbumCollectionView.reloadData()
    }
    
    @objc private func fetchedPhotosResult() {
        let messageLabelHeight: CGFloat = PhotoStore.results.isEmpty ? 80.0 : 0.0
        let messageLabelAlpha: CGFloat = PhotoStore.results.isEmpty ? 1.0 : 0.0
        let collectionViewAlpha: CGFloat = PhotoStore.results.isEmpty ? 0.0 : 1.0
        
        updateUIWithAnimation(messageLabelHeight, collectionViewAlpha: collectionViewAlpha, messageLabelAlpha: messageLabelAlpha)
        
        if PhotoStore.results.isEmpty {
            PhotoStore.results.removeAll()
        }
        
        photoAlbumCollectionView.reloadData()
    }
    
    private func updateUIWithAnimation(_ height: CGFloat, collectionViewAlpha: CGFloat, messageLabelAlpha: CGFloat) {
        UIView.animate(withDuration: 0.8) {
            self.messageLabelHeightConstraint.constant = height
            self.messageLabel.alpha = messageLabelAlpha
            self.photoAlbumCollectionView.alpha = collectionViewAlpha
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PhotoAlbumViewController: MKMapViewDelegate { }
