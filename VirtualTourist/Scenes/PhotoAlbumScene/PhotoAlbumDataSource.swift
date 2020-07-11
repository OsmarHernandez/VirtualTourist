//
//  PhotoAlbumDataSource.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 20/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import CoreData

class PhotoAlbumDataSource: NSObject, UICollectionViewDataSource {
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoAlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoCellIdentifier, for: indexPath) as! PhotoAlbumViewCell
        
        photoAlbumCell.updateUI(with: nil)
        
        return photoAlbumCell
    }
}

extension PhotoAlbumDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoAlbumCell = cell as? PhotoAlbumViewCell else { return }
        
        let photo = fetchedResultsController.object(at: indexPath)
        
        func updateUI(_ data: Data) {
            let downloadedImage = UIImage(data: data)
            photoAlbumCell.updateUI(with: downloadedImage)
            photoAlbumCell.setNeedsLayout()
        }
        
        if photo.hasDownloadedImage {
            print("Existing image in Core Data")
            updateUI(photo.imageData!)
        } else {
            FlickrClient.downloadImage(from: photo.imageURL!) { (data, error) in
                guard let data = data else { return }
                
                print("Downloading image for first time")
                updateUI(data)
                DataController.shared.saveImageToAssociatedPhoto(data: data, photo: photo)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoToDelete = fetchedResultsController.object(at: indexPath)
        DataController.shared.viewContext.delete(photoToDelete)
        try? DataController.shared.viewContext.save()
    }
}

extension PhotoAlbumDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 3
        let collectionViewWidth = collectionView.bounds.width
        let flowlayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowlayout.minimumInteritemSpacing * (columns - 1)
        let adjustedWidth = collectionViewWidth - spaceBetweenCells
        
        let side = floor(adjustedWidth / columns)
        
        return CGSize(width: side, height: side)
    }
}
