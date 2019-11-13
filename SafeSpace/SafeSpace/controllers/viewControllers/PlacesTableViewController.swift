//
//  PlacesTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/11/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    let places: [Places] = []
    
    @IBOutlet weak var placesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    @IBAction func placesButtonTapped(_ sender: Any) {
       // presentAlertController(for: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PlacesController.sharedPlaces.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath)
        let place = PlacesController.sharedPlaces.places[indexPath.row]
        cell.textLabel?.text = place.placesName
        cell.detailTextLabel?.text = place.placesComment
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeToUpdate = PlacesController.sharedPlaces.places[indexPath.row]
        //presentAlertController(for: placeToUpdate)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let placeToDelete = PlacesController.sharedPlaces.places[indexPath.row]
            guard let index = PlacesController.sharedPlaces.places.firstIndex(of: placeToDelete) else {return}
            PlacesController.sharedPlaces.delete(placeToDelete) { (success) in
                if success {
                    PlacesController.sharedPlaces.places.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let detailVC = segue.destination as? PlacesDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                let places = PlacesController.sharedPlaces.places[selectedRow]
                detailVC.places = places
            }
        }
    }
    
    
    // MARK: - Methods
    
    /*
    func presentAlertController(for place: Places?) {
        let alertcontroller = UIAlertController(title: "Enter a favorite place", message: "One of you favorite spots that you can relax", preferredStyle: .alert)
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter the place here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let place = place {
                textfield.text = place.placesName
            }
        }
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Why is place important?"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let place = place {
                textfield.text = place.placesComment
            }
        }
        
        let postAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let placeName = alertcontroller.textFields?[0].text,
                let placeComment = alertcontroller.textFields?[1].text,
                !placeName.isEmpty else {return}
            if let place = place {
                place.placesName = placeName
                place.placesComment = placeComment
                PlacesController.sharedPlaces.updatePlaces(place) { (success) in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                
                PlacesController.sharedPlaces.savePlaces(with: placeName, placeComment: placeComment, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertcontroller.addAction(postAction)
        alertcontroller.addAction(cancelAction)
        present(alertcontroller, animated: true)
    }*/
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        PlacesController.sharedPlaces.fetchPlaces { (success) in
            if success {
                self.updateViews()
            }
        }
    }
}
