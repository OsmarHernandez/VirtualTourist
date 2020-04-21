//
//  PhotoAlbumViewCell.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 18/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

class PhotoAlbumViewCell: UICollectionViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateUI(with: nil)
    }
    
    func updateUI(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            customImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            customImageView.image = nil
        }
    }
}
