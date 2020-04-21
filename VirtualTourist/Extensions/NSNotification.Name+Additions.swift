//
//  NSNotification.Name+Additions.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 17/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static var didEnterBackground: NSNotification.Name {
        return NSNotification.Name("Application.DidEnterBackground")
    }
    
    static var willEnterForeground: NSNotification.Name {
        return NSNotification.Name("Application.WillEnterForeground")
    }
    
    static var fetchedPhotos: NSNotification.Name {
        return NSNotification.Name("NetworkRequest.GetPhotos")
    }
}
