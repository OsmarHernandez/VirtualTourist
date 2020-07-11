//
//  Photo+Extension.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 10/07/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

extension Photo {
    
    var hasDownloadedImage: Bool {
        return self.imageData != nil
    }
}
