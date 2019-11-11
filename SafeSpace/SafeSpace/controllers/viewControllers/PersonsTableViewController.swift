//
//  PersonsTableViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/11/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class PersonsTableViewController: UITableViewController {
    let person: [Persons] = []
    
    @IBOutlet weak var peopleButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    @IBAction func peopleButtonTapped(_ sender: Any) {
        presentAlertController(for: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PersonController.sharedPeople.persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
        let person = PersonController.sharedPeople.persons[indexPath.row]
        cell.textLabel?.text = person.peopleName
        cell.detailTextLabel?.text = person.peoplePhone
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personToUpdate = PersonController.sharedPeople.persons[indexPath.row]
        presentAlertController(for: personToUpdate)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToDelete = PersonController.sharedPeople.persons[indexPath.row]
            guard let index = PersonController.sharedPeople.persons.firstIndex(of: personToDelete) else {return}
            PersonController.sharedPeople.delete(personToDelete) { (success) in
                if success {
                    PersonController.sharedPeople.persons.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Methods
    
    
    func presentAlertController(for person: Persons?) {
        let alertcontroller = UIAlertController(title: "Enter a person who helps you", message: "Friend, family, professional...", preferredStyle: .alert)
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter person name here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let person = person {
                textfield.text = person.peopleName
            }
        }
        alertcontroller.addTextField { (textfield) in
            textfield.placeholder = "Enter their phone number here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            if let person = person {
                textfield.text = person.peoplePhone
            }
        }
        
        let postAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let personName = alertcontroller.textFields?[0].text,
                let personPhone = alertcontroller.textFields?[1].text,
                !personName.isEmpty else {return}
            if let person = person {
                person.peopleName = personName
                person.peoplePhone = personPhone
                PersonController.sharedPeople.updatePerson(person) { (success) in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                
                PersonController.sharedPeople.savePerson(with: personName, personNumber: personPhone, completion: { (success) in
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
        PersonController.sharedPeople.fetchPersons { (success) in
            if success {
                self.updateViews()
            }
        }
    }
}
