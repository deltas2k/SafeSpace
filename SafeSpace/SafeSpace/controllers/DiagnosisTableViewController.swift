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
        DiagnosisController.sharedDiagnosis.fetchDiagnosis { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    @IBAction func diagnosisButtonTapped(_ sender: Any) {
        //presentAlertController(for: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let diagToUpdate = DiagnosisController.sharedDiagnosis.diagnosis[indexPath.row]
//        presentAlertController(for: diagToUpdate)
//    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let detailVC = segue.destination as? DiagnosisDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                let diagnosis = DiagnosisController.sharedDiagnosis.diagnosis[selectedRow]
                detailVC.diagnosis = diagnosis
            }
        }
    }
    
    
    // MARK: - Methods
    
    
    /*func presentAlertController(for diagnosis: Diagnosis?) {
     let alertcontroller = UIAlertController(title: "Enter Diagnosis", message: "Enter a diagnosis here", preferredStyle: .alert)
     alertcontroller.addTextField { (textfield) in
     textfield.placeholder = "Enter diagnosis here"
     textfield.autocorrectionType = .yes
     textfield.autocapitalizationType = .sentences
     if let diagnosis = diagnosis {
     textfield.text = diagnosis.diagnosisTitle
     }
     }
     alertcontroller.addTextField { (textfield) in
     textfield.placeholder = "Comment what that means to you"
     textfield.autocorrectionType = .yes
     textfield.autocapitalizationType = .sentences
     if let diagnosis = diagnosis {
     textfield.text = diagnosis.diagnosisComment
     }
     }
     
     let postAction = UIAlertAction(title: "Save", style: .default) { (_) in
     guard let diagName = alertcontroller.textFields?[0].text,
     let diagComment = alertcontroller.textFields?[1].text,
     !diagName.isEmpty else {return}
     if let diagnosis = diagnosis {
     diagnosis.diagnosisTitle = diagName
     diagnosis.diagnosisComment = diagComment
     DiagnosisController.sharedDiagnosis.updateDiagnosis(diagnosis) { (success) in
     DispatchQueue.main.async {
     self.tableView.reloadData()
     }
     }
     } else {
     
     DiagnosisController.sharedDiagnosis.saveDiagnosis(with: diagName, diagDose: diagComment) { (success) in
     if success {
     DispatchQueue.main.async {
     self.tableView.reloadData()
     }
     
     }
     }
     }
     }
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     alertcontroller.addAction(postAction)
     alertcontroller.addAction(cancelAction)
     present(alertcontroller, animated: true)
     }
     */
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


