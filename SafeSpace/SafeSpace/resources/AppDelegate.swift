//
//  AppDelegate.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 10/27/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkAccountStatus { (hasAccount) in
            if hasAccount == false {
                let tabBarController = UIApplication.shared.windows.first?.rootViewController
                let errorText = "To use this app, please login to iCloud in Settings"
                tabBarController?.presentSimpleAlertWith(title: errorText, message: nil)
            }
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func checkAccountStatus(completion: @escaping (Bool) -> Void) {
        CKContainer.default().accountStatus { (accountStatus, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            } else {
                DispatchQueue.main.async {
                    switch accountStatus {
                    case .available:
                        completion(true)
                    case .noAccount:
                        completion(false)
                    case .couldNotDetermine:
                        completion(false)
                    case .restricted:
                        completion(false)
                    @unknown default:
                        completion(false)
                    }
                }
            }
        }
    }
}

