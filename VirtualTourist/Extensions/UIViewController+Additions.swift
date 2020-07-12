//
//  UIViewController+Additions.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 10/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func fetchPhotos(for selectedPin: Pin) {
        let additionalParams = Constants.additionalParameters(selectedPin.latitude!, selectedPin.longitude!)
        
        FlickrClient.getPhotos(additionalParams) { (photoResponse, error) in
            guard let photoResponse = photoResponse else { return }
            
            for photo in photoResponse.photos{
                if photo.urlH == nil { continue }
                DataController.shared.addPhoto(photo, pin: selectedPin)
            }
            
            Constants.pages = photoResponse.pages
        }
    }
}
