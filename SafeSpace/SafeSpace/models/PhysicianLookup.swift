//
//  PhysicianLookup.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/6/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation

struct PhysicianQuery: Decodable {
    let businesses: [Businesses]
    
}

struct Businesses: Decodable {
    let id: String
    let name: String
    let image_url: String?
    let url: String
    let rating: Double
    let review_count: Int
    let display_phone: String
    let location: Location
    let coordinates: Coordinates
    
}

struct Location: Decodable {
    let address1: String?
    let address2: String?
    let city: String
    let state: String
    let zip_code: String
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

