//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 16/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    @IBOutlet weak var messageLabelHeightConstraint: NSLayoutConstraint!
    
    var pin: Pin!
    
    let photoAlbumDataSource = PhotoAlbumDataSource()
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        photoAlbumDataSource.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        photoAlbumDataSource.fetchedResultsController.delegate = self
        
        do {
            try photoAlbumDataSource.fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch couldn't be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        photoAlbumCollectionView.delegate = photoAlbumDataSource
        photoAlbumCollectionView.dataSource = photoAlbumDataSource
        
        mapView.setCenter(pin.coordinate, animated: true)
        addAnnotation(mapView, coordinate: pin.coordinate)
        
        configureUI()
    }
    
    @IBAction func newCollectionButtonTapped(_ sender: UIButton) {
        if let photos = photoAlbumDataSource.fetchedResultsController.fetchedObjects {
            DataController.shared.deletePhoto(photos)
        }
        fetchPhotos(for: pin)
    }
    
    private func configureUI() {
        let hasPhotos = photoAlbumDataSource.fetchedResultsController.sections![0].numberOfObjects > 0
        
        let messageLabelHeight: CGFloat = hasPhotos ? 0.0 : 80.0
        let messageLabelAlpha: CGFloat = hasPhotos ? 0.0 : 1.0
        let collectionViewAlpha: CGFloat = hasPhotos ? 1.0 : 0.0
        
        updateUIWithAnimation(messageLabelHeight, collectionViewAlpha: collectionViewAlpha, messageLabelAlpha: messageLabelAlpha)
    }
    
    private func updateUIWithAnimation(_ height: CGFloat, collectionViewAlpha: CGFloat, messageLabelAlpha: CGFloat) {
        UIView.animate(withDuration: 0.8) {
            self.messageLabelHeightConstraint.constant = height
            self.messageLabel.alpha = messageLabelAlpha
            self.photoAlbumCollectionView.alpha = collectionViewAlpha
        }
    }
    
    deinit {
        photoAlbumDataSource.fetchedResultsController = nil
        photoAlbumCollectionView.delegate = nil
        photoAlbumCollectionView.dataSource = nil
        Constants.pages = 1
    }
}

extension PhotoAlbumViewController: MKMapViewDelegate { }

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureUI()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            photoAlbumCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            photoAlbumCollectionView.deleteItems(at: [indexPath!])
        default:
            break
        }
    }
}
