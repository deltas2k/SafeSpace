//
//  PlacesDetailViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/12/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class PlacesDetailViewController: UIViewController {
    var places: Places? {
            didSet {
                DispatchQueue.main.async {
                    self.loadViewIfNeeded()
                    self.updateViews()
                }
            }
        }
        @IBOutlet weak var titleTextField: UITextField!
        
        @IBOutlet weak var bodyTextView: UITextView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.updateViews()
            bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
            bodyTextView.layer.borderWidth = 0.25
            bodyTextView.layer.cornerRadius = 8.0
            bodyTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            // Do any additional setup after loading the view.
        }
        
        @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
                let body = bodyTextView.text
                else {return}
                if let places = places {
                    places.placesName = title
                    places.placesComment = body
                        
                    PlacesController.sharedPlaces.updatePlaces(places) { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    } else {
                        // save new
                    PlacesController.sharedPlaces.savePlaces(with: title, placeComment: body) { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                
                            }
                        }
                        
                    }
                }
            }
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                titleTextField.resignFirstResponder()
            }
            
            func updateViews() {
                if let places = places {
                    titleTextField.text = places.placesName
                    bodyTextView.text = places.placesComment
                }
            }
    }
