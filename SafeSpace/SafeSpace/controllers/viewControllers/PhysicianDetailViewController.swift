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
    @IBAction func phoneButtonClicked(_ sender: Any) {
        makePhoneCall(phoneNumber: businesses?.phone ?? "")
    }
    @IBAction func addressButtonTapped(_ sender: Any) {
        getDirections()
        
    }
    @IBAction func yelpButtonTapped(_ sender: Any) {
         clickYelp()
    }
    
    func clickYelp() {
        guard let businesses = businesses else {return}
        guard let businessURL = URL(string: businesses.url) else {return}
        UIApplication.shared.open(businessURL as URL)
    }
    
    
    func getDirections() {
        guard let businesses = businesses else {return}
        
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(businesses.coordinates.latitude), CLLocationDegrees(businesses.coordinates.longitude))
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = businesses.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            
            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
        addressButton.setTitle(self.setDisplayAddress(), for: .normal)
        
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
        
        PhysicianController.getImage(image: businesses) { (image) in
            DispatchQueue.main.async {
                self.physicianImageView.image = image
                
            }
        }
    }
    
    
    func setDisplayAddress() -> String {
        guard let Address1 = businesses?.location.address1,
            let Address2 = businesses?.location.address2,
            let City = businesses?.location.city,
            let State = businesses?.location.state,
            let zipCode = businesses?.location.zip_code
            else {return ""}
        
        let newAddress = "\(Address1)\n\(Address2)\n\(City), \(State) \(zipCode)"
        return newAddress
    }
}

