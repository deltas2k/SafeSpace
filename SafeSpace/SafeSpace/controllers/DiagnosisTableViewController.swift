//
//  DiagnosisTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/9/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class DiagnosisTableViewController: UITableViewController {
    let diagnosis: [Diagnosis] = []
    
    @IBOutlet weak var diagnosisButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    @IBAction func diagnosisButtonTapped(_ sender: Any) {
        presentAlertController(for: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DiagnosisController.sharedDiagnosis.diagnosis.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diagnosisCell", for: indexPath)
        let diagnosis = DiagnosisController.sharedDiagnosis.diagnosis[indexPath.row]
        cell.textLabel?.text = diagnosis.diagnosisTitle
        cell.detailTextLabel?.text = diagnosis.diagnosisComment
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diagToUpdate = DiagnosisController.sharedDiagnosis.diagnosis[indexPath.row]
        presentAlertController(for: diagToUpdate)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let diagToDelete = DiagnosisController.sharedDiagnosis.diagnosis[indexPath.row]
            guard let index = DiagnosisController.sharedDiagnosis.diagnosis.firstIndex(of: diagToDelete) else {return}
            DiagnosisController.sharedDiagnosis.delete(diagToDelete) { (success) in
                if success {
                    DiagnosisController.sharedDiagnosis.diagnosis.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }    
    }


    
    // MARK: - Methods

    
    func presentAlertController(for diagnosis: Diagnosis?) {
        let alertcontroller = UIAlertController(title: "Enter Diagnosis", message: "Enter a diagnosis here", preferredStyle: .alert)
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter diagnosis here"
        }
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Comment what that means to you"
        }
        
        let postAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let diagName = alertcontroller.textFields?[0].text,
                let diagComment = alertcontroller.textFields?[1].text,
                !diagName.isEmpty else {return}
            DiagnosisController.sharedDiagnosis.saveDiagnosis(with: diagName, diagDose: diagComment) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
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
        DiagnosisController.sharedDiagnosis.fetchDiagnosis { (success) in
            if success {
                self.updateViews()
            }
        }
    }

}
