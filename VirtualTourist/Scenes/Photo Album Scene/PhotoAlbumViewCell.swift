//
//  PhotoAlbumViewCell.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 18/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

class PhotoAlbumViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoAlbumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10.0
    }
}
