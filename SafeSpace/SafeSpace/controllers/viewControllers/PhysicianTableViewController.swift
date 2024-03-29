//
//  PhysicianTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/6/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit
import CoreLocation

class PhysicianTableViewController: UITableViewController {
    let locationManager = CLLocationManager()
    var currentLat: Double = 0
    var currentLong: Double = 0
    var currentRadius: Int = 40000
    
    
    @IBOutlet weak var physicianSearchBar: UISearchBar!
    @IBOutlet weak var distanceSegmentedController: UISegmentedControl!
    
    
    var businesses: [Businesses] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        physicianSearchBar.delegate = self
        locationManager.requestWhenInUseAuthorization()
        getLocation()
        tableView.rowHeight = 120
    }
    
    @IBAction func distanceSCTapped(_ sender: UISegmentedControl) {
        if distanceSegmentedController.selectedSegmentIndex == 0 {
            currentRadius = 8047
        } else if distanceSegmentedController.selectedSegmentIndex == 1 {
            currentRadius = 16093
        } else if distanceSegmentedController.selectedSegmentIndex == 2 {
            currentRadius = 24140
        } else if distanceSegmentedController.selectedSegmentIndex == 3 {
            currentRadius = 32186
        } else if distanceSegmentedController.selectedSegmentIndex == 4 {
            currentRadius = 40000
        }
        getPhysicianSearch()
    }
    
    func getPhysicianSearch() {
        guard let searchText = physicianSearchBar.text else {return}
        if searchText != "" {
            currentLat = 0
            currentLong = 0
            PhysicianController.sharedPhysician.buildQueryLink(with: searchText, lat: currentLat, long: currentLong, radius: currentRadius) { (results) in
                self.businesses = results
            }
        } else if searchText == "" {
            currentLat = locationManager.location?.coordinate.latitude ?? 0
            currentLong = locationManager.location?.coordinate.longitude ?? 0
            PhysicianController.sharedPhysician.buildQueryLink(with: searchText, lat: currentLat, long: currentLong, radius: currentRadius) { (results) in
                self.businesses = results
            }
        }
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return businesses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "physicianCell", for: indexPath) as! PhysicianTableViewCell

        let business = businesses[indexPath.row]
        cell.physicians = business
        // cell.textLabel?.text = business.name

        return cell
    }



    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toDestinationVC" {
               guard let detailVC = segue.destination as? PhysicianDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow else {return}
            let business = businesses[selectedRow.row]
                detailVC.businesses = business
               
           }
       }
    

}

extension PhysicianTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getPhysicianSearch()
    }
}

//MARK: - Location gathering
extension PhysicianTableViewController: CLLocationManagerDelegate {
    func getLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("lat: \(locValue.latitude), long: \(locValue.longitude)")
        self.currentLat = locValue.latitude
        self.currentLong = locValue.longitude
    }
}

