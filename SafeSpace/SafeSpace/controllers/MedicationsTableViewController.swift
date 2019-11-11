//
//  MedicationsTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/11/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class MedicationsTableViewController: UITableViewController {

    let medications: [Medications] = []
    
    @IBOutlet weak var medicationsButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    @IBAction func medicationButtonTapped(_ sender: Any) {
        presentAlertController(for: nil)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
        return MedicationsController.sharedMedications.medications.count
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath)
            let medication = MedicationsController.sharedMedications.medications[indexPath.row]
            cell.textLabel?.text = medication.medName
            cell.detailTextLabel?.text = medication.medDosage
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let medToUpdate = MedicationsController.sharedMedications.medications[indexPath.row]
            presentAlertController(for: medToUpdate)
        }

        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let medToDelete = MedicationsController.sharedMedications.medications[indexPath.row]
                guard let index = MedicationsController.sharedMedications.medications.firstIndex(of: medToDelete) else {return}
                MedicationsController.sharedMedications.delete(medToDelete) { (success) in
                    if success {
                        MedicationsController.sharedMedications.medications.remove(at: index)
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
        }


        
        // MARK: - Methods

        
        func presentAlertController(for medications: Medications?) {
            let alertcontroller = UIAlertController(title: "Enter Medication", message: "Enter a mediction here", preferredStyle: .alert)
            alertcontroller.addTextField { (textfield) in
                textfield.placeholder = "Enter medication name here"
                textfield.autocorrectionType = .yes
                textfield.autocapitalizationType = .sentences
                if let medication = medications {
                    textfield.text = medication.medName
                }
            }
            alertcontroller.addTextField { (textfield) in
                textfield.placeholder = "Enter medication's dosage here"
                textfield.autocorrectionType = .yes
                textfield.autocapitalizationType = .sentences
                if let medication = medications {
                    textfield.text = medication.medDosage
                }
            }
            
            let postAction = UIAlertAction(title: "Save", style: .default) { (_) in
                guard let medName = alertcontroller.textFields?[0].text,
                    let medDosage = alertcontroller.textFields?[1].text,
                    !medName.isEmpty else {return}
                if let medication = medications {
                    medication.medName = medName
                    medication.medDosage = medDosage
                    MedicationsController.sharedMedications.updateMedications(medication) { (success) in
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    
                    MedicationsController.sharedMedications.saveMedications(with: medName, drugDose: medDosage, completion: { (success) in
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
            MedicationsController.sharedMedications.fetchMedications { (success) in
                if success {
                    self.updateViews()
                }
            }
        }

    }
