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
    @IBOutlet weak var moodScoreDisplayLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }
    
    @IBOutlet weak var happinessaBarSlide: UISlider!
    
    @IBAction func happinessBarSlideChanged(_ sender: Any) {
        entry?.happinessBar = Int(happinessaBarSlide.value)
        moodScoreDisplayLabel.text = String(Int(happinessaBarSlide.value))
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
        let happinessBar = Int(happinessaBarSlide.value)
        if let entry = entry {
            entry.titleText = title
            entry.bodyText = body
            entry.happinessBar = happinessBar
            
            EntryController.shared.update(entry) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            // save new
            EntryController.shared.saveEntry(with: title, bodyText: body, happinessBar: happinessBar) { (success) in
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
            happinessaBarSlide.value = Float(entry.happinessBar)
            moodScoreDisplayLabel.text = String(entry.happinessBar)
            print("entry loaded")
        }
    }
}


