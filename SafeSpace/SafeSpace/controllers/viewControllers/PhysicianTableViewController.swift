//
//  PhysicianTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/6/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class PhysicianTableViewController: UITableViewController {
    @IBOutlet weak var physicianSearchBar: UISearchBar!
    
    
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return businesses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "physicianCell", for: indexPath)

        let business = businesses[indexPath.row]
        cell.textLabel?.text = business.name

        return cell
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhysicianTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //PhysicianController.sharedPhysician.buildQueryLink(with: searchText.lowercased(), lat: 0, long: 0, radius: <#T##Int#>, completion: <#T##([Businesses]) -> Void#>)
    }
}
