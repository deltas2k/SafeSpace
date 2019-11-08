//
//  EntryDetailViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit


class EntryDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        self.updateViews()
        bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
        bodyTextView.layer.borderWidth = 0.25
        bodyTextView.layer.cornerRadius = 8.0
        bodyTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let body = bodyTextView.text
            else {return}
        
        if let entry = entry {
            EntryController.shared.updateEntry(entry) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            // save new
            EntryController.shared.addEntryWith(titleText: title, bodyText: body) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        titleTextField.text = ""
        bodyTextView.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
    }
    
    func updateViews() {
        if let entry = entry {
            titleTextField.text = entry.titleText
            bodyTextView.text = entry.bodyText
            print("entry loaded")
        }
    }
}


