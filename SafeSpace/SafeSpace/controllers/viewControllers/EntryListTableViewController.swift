//
//  JournalTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.shared.fetchEntries { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    // MARK: - Table view data source
    
    func updateViews () {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.shared.entry.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let entry = EntryController.shared.entry[indexPath.row]
        cell.textLabel?.text = entry.titleText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           //we grab the hype we want to delete from indexpath
        let entryToDelete = EntryController.shared.entry[indexPath.row]
           //make sure that the hype exists in the hypes array
        guard let index = EntryController.shared.entry.firstIndex(of: entryToDelete) else {return}
           //call our delete method to delete the hype
           EntryController.shared.delete(entryToDelete) { (success) in
               //if it deletes successfully, we remove the hype from SOT and delete the row
               if success {
                EntryController.shared.entry.remove(at: index)
                   DispatchQueue.main.async {
                       tableView.deleteRows(at: [indexPath], with: .automatic)
                   }
               }
           }
       }
   }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let detailVC = segue.destination as? EntryDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                let entry = EntryController.shared.entry[selectedRow]
                detailVC.entry = entry
            }
        }
    }
}
