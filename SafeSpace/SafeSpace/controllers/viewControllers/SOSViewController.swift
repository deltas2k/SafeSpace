//
//  SOSViewController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/4/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class SOSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func policeButtonTapped(_ sender: Any) {
        makePhoneCall(phoneNumber: "911")
    }
    @IBAction func lifelineButtonTapped(_ sender: Any) {
        makePhoneCall(phoneNumber: "18002738255")
    }
    @IBAction func SAMHSAHotlineButtonTapped(_ sender: Any) {
        makePhoneCall(phoneNumber: "18006622357")
    }
    @IBAction func disasterButtonTapped(_ sender: Any) {
        makePhoneCall(phoneNumber: "18009855990")
    }
    @IBAction func veteransButtonTapped(_ sender: Any) {
        makePhoneCall(phoneNumber: "18002738255")
    }
    @IBAction func TTYButtonTapped(_ sender: Any) {
        makePhoneCall(phoneNumber: "18004874889")
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
        

}
