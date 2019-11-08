//
//  PhysicianController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/6/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class PhysicianController {
    let baseURL = URL(string: DoctorConstants.baseURL)
    
    var businesses: [Businesses] = []
    
    static let sharedPhysician = PhysicianController()
    
    func buildQueryLink(with searchText: String, lat: Double, long: Double, radius: Int, completion: @escaping ([Businesses]) -> Void) {
        guard let url = baseURL else {completion([]); return}
        var componentURL = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let queryCategory = URLQueryItem(name: DoctorConstants.specialtyQueryKey, value: DoctorConstants.specialtyQueryValue)
        let queryRadius = URLQueryItem(name: DoctorConstants.radiusQueryKey, value: "\(radius)")
        let queryLimit = URLQueryItem(name: DoctorConstants.limitQueryKey, value: DoctorConstants.limitQueryValue)
        let querySortby = URLQueryItem(name: DoctorConstants.sortbyQueryKey, value: DoctorConstants.sortbyQueryValue)
        
        componentURL?.queryItems = [queryCategory, queryRadius, queryLimit, querySortby]
        
        if searchText != "" {
            let queryLocation = URLQueryItem(name: DoctorConstants.locationQueryKey, value: searchText)
            componentURL?.queryItems?.append(queryLocation)
        }
        if lat != 0 && long != 0 {
            let queryLong = URLQueryItem(name: DoctorConstants.longitudeQueryKey, value: "\(long)")
            let queryLat = URLQueryItem(name: DoctorConstants.latitudeQueryKey, value: "\(lat)")
            componentURL?.queryItems?.append(queryLat)
            componentURL?.queryItems?.append(queryLong)
        }
        
        guard let finalURL = componentURL?.url else {completion([]); return}
        print(finalURL)
        
        var request = URLRequest(url: finalURL)
        request.addValue(DoctorConstants.apiHeaderValue, forHTTPHeaderField: DoctorConstants.apiHeaderKey)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion([]); return
            }
            guard let data = data else {completion([]); return}
            do {
                let decode = try JSONDecoder().decode(PhysicianQuery.self, from: data)
                completion(decode.businesses)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        .resume()

    }
    
    static func getImage(image: Businesses, completion: @escaping (UIImage) -> Void) {
        guard let url = image.image_url else {return}
        guard let finalURL = URL(string: url) else {return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
            if let data = data {
                guard let image = UIImage(data: data) else {return}
                completion(image)
                    }
                }
            .resume()
        
    }
    

}
