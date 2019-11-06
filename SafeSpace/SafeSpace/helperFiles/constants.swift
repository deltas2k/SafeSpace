//
//  constants.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/4/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

/// api-key: 4f3aa17cf0f7027abdb9ed61426ea1d7

/// https://api.betterdoctor.com/2016-03-01/doctors?specialty_uid=psychiatrist&location=37.773%2C-122.413%2C100&skip=0&limit=10&user_key=4f3aa17cf0f7027abdb9ed61426ea1d7

import Foundation

struct DoctorConstants {
    static let baseURL = "https://api.betterdoctor.com/2016-03-01/doctors"
    static let specialtyQueryKey = "specialty_uid"
    static let specialtyQueryValue = "psychiatrist"
    static let locationQueryKey = "location"
    static let skipQueryKey = "skip"
    static let skipQueryValue = "0"
    static let limitQueryKey = "limit"
    static let limitQueryValue = "50"
    static let apiQueryKey = "user_key"
    static let apiQueryValue = "4f3aa17cf0f7027abdb9ed61426ea1d7"
    static let imageURL = "https://asset2.betterdoctor.com/images/"
    
}
