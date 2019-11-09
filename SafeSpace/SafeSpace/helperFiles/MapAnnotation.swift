//
//  MapAnnotation.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/8/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    
}
