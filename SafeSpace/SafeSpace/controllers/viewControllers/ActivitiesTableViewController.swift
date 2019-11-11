//
//  ActivitiesTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/11/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class ActivitiesTableViewController: UITableViewController {
    
    @IBOutlet weak var activitiesButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    @IBAction func activitiesButtonTapped(_ sender: Any) {
        presentAlertController(for: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ActivitesController.sharedActivities.activities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activitesCell", for: indexPath)
        let activity = ActivitesController.sharedActivities.activities[indexPath.row]
        cell.textLabel?.text = activity.activities
        cell.detailTextLabel?.text = activity.activitiesComment
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityToUpdate = ActivitesController.sharedActivities.activities[indexPath.row]
        presentAlertController(for: activityToUpdate)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let activityToDelete = ActivitesController.sharedActivities.activities[indexPath.row]
            guard let index = ActivitesController.sharedActivities.activities.firstIndex(of: activityToDelete) else {return}
            ActivitesController.sharedActivities.delete(activityToDelete) { (success) in
                if success {
                    ActivitesController.sharedActivities.activities.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Methods
    
    
    func presentAlertController(for activity: Activities?) {
        let alertcontroller = UIAlertController(title: "Enter some of your favorite activities", message: "Enter an activity here", preferredStyle: .alert)
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter activity here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let activity = activity {
                textfield.text = activity.activities
            }
        }
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter some comments about the activity here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let activity = activity  {
                textfield.text = activity.activitiesComment
            }
        }
        
        let postAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let activityName = alertcontroller.textFields?[0].text,
                let activityComment = alertcontroller.textFields?[1].text,
                !activityName.isEmpty else {return}
            if let activity = activity  {
                activity.activities = activityName
                activity.activitiesComment = activityComment
                ActivitesController.sharedActivities.updateActivities(activity) { (success) in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                
                ActivitesController.sharedActivities.saveActivities(with: activityName, activityComment: activityComment, completion: { (success) in
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
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        ActivitesController.sharedActivities.fetchActivities { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
}
