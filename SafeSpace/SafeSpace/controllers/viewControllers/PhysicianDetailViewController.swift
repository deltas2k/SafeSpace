//
//  PhysicianDetailViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/8/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit
import MapKit

class PhysicianDetailViewController: UIViewController {

    @IBOutlet weak var physicianImageView: UIImageView!
    
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    
    var businesses: Businesses? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func updateViews() {
        guard let businesses = businesses else {return}
        businessNameLabel.text = businesses.name
        phoneButton.setTitle(businesses.display_phone, for: .normal)
        
        let initialLocation = CLLocation(latitude: businesses.coordinates.latitude, longitude: businesses.coordinates.longitude)
        
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        
        let location = MapAnnotation(title: businesses.name, coordinate: CLLocationCoordinate2DMake(businesses.coordinates.latitude, businesses.coordinates.longitude))
        mapView.addAnnotation(location)
    }
}

