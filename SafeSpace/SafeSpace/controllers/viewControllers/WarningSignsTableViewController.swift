//
//  WarningSignsTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/11/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class WarningSignsTableViewController: UITableViewController {

    let warningSign: [RecognizeWS] = []
    
    @IBOutlet weak var warningSignsButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    @IBAction func warningSignButtonTapped(_ sender: Any) {
      //  presentAlertController(for: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WarningSignsController.sharedWS.recognizeWS.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recognizeWSCell", for: indexPath)
        let warningSign = WarningSignsController.sharedWS.recognizeWS[indexPath.row]
        cell.textLabel?.text = warningSign.recognizeWSTitle
        cell.detailTextLabel?.text = warningSign.recognizeWSComment
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wsToUpdate = WarningSignsController.sharedWS.recognizeWS[indexPath.row]
      //  presentAlertController(for: wsToUpdate)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let wsToDelete = WarningSignsController.sharedWS.recognizeWS[indexPath.row]
            guard let index = WarningSignsController.sharedWS.recognizeWS.firstIndex(of: wsToDelete) else {return}
            WarningSignsController.sharedWS.delete(wsToDelete) { (success) in
                if success {
                    WarningSignsController.sharedWS.recognizeWS.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let detailVC = segue.destination as? WarningSignDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                
                let recognizeWS = WarningSignsController.sharedWS.recognizeWS[selectedRow]
                detailVC.recognizeWS = recognizeWS
            }
        }
    }
    
    
    // MARK: - Methods
    
    /*
    func presentAlertController(for warningSign: RecognizeWS?) {
        let alertcontroller = UIAlertController(title: "Enter your warning signs", message: "Enter a warning signs here", preferredStyle: .alert)
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter warning sign name here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let warningSign = warningSign {
                textfield.text = warningSign.recognizeWSTitle
            }
        }
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter warning sign's comments here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let warningSign = warningSign {
                textfield.text = warningSign.recognizeWSComment
            }
        }
        
        let postAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let wsName = alertcontroller.textFields?[0].text,
                let wsComment = alertcontroller.textFields?[1].text,
                !wsName.isEmpty else {return}
            if let warningSign = warningSign {
                warningSign.recognizeWSTitle = wsName
                warningSign.recognizeWSComment = wsComment
                WarningSignsController.sharedWS.updateWarningSign(warningSign) { (success) in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                
                WarningSignsController.sharedWS.saveWarningSigns(with: wsName, wsComment: wsComment, completion: { (success) in
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
        WarningSignsController.sharedWS.fetchWarningSign { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
}
