//
//  DiagnosisDetailViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/12/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class DiagnosisDetailViewController: UIViewController {

    var diagnosis: Diagnosis? {
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
        if let diagnosis = diagnosis {
            diagnosis.diagnosisTitle = title
            diagnosis.diagnosisComment = body
                
            DiagnosisController.sharedDiagnosis.updateDiagnosis(diagnosis) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            } else {
                // save new
            DiagnosisController.sharedDiagnosis.saveDiagnosis(with: title, diagDose: body) { (success) in
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
        if let diagnosis = diagnosis {
            titleTextField.text = diagnosis.diagnosisTitle
            bodyTextView.text = diagnosis.diagnosisComment
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
