//
//  constants.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/4/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

/*
 Client ID
 hCkElk1FQSuJDaQfY7WHzw

 API Key
 Is4MxdjB5xyV2U4jrnk737ETNec4KxUUV36ovgowIO3RfVOv9k092xCQ6Bgz4zRURsqAE2i1ptv_RTsthBMNomWnJ_mmLSvTHjb9FxPbzyhl5gpwdXXcUAA8CArDXXYx
 
 https://api.yelp.com/v3/businesses/search
 https://api.yelp.com/v3/businesses/search?longitude=-111.758381&latitude=40.365462&categories=c_and_mh&radius=40000
 
 */

import Foundation

struct DoctorConstants {
    static let baseURL = "https://api.yelp.com/v3/businesses/search"
    static let specialtyQueryKey = "categories"
    static let specialtyQueryValue = "c_and_mh"
    static let longitudeQueryKey = "longitude"
    static let latitudeQueryKey = "latitude"
    static let radiusQueryKey =  "radius"
    static let locationQueryKey = "location"
    static let apiHeaderKey = "Authorization"
    static let apiHeaderValue = "Bearer Is4MxdjB5xyV2U4jrnk737ETNec4KxUUV36ovgowIO3RfVOv9k092xCQ6Bgz4zRURsqAE2i1ptv_RTsthBMNomWnJ_mmLSvTHjb9FxPbzyhl5gpwdXXcUAA8CArDXXYx"
    static let limitQueryKey = "limit"
    static let limitQueryValue = "50"
    static let sortbyQueryKey = "sort_by"
    static let sortbyQueryValue = "best_match"
    
}
