//
//  JournalController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    static let shared = EntryController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.SafeSpace2").privateCloudDatabase
    var entry: [Entry] = []
    
    func saveEntry(with text: String, bodyText: String, completion: @escaping (_ success: Bool) -> Void) {
        let newEntry = Entry(titleText: text, bodyText: bodyText)
        // Initalizes a new CKRecord with a Hype using our convenience init on our CKRecord extension
        let hypeRecord = CKRecord(entry: newEntry)
        // Access the save method on our database to save the hypeRecord, completes with an optional record and error
        privateDB.save(hypeRecord) { (record, error) in
            // Handling the error. If there is one, print the description and complete false
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            // Unwrap the record that was saved, then turning into our Model object using our failable convenience initializer
            guard let record = record,
                let savedEntry = Entry(ckRecord: record)
                else { completion(false) ; return }
            // Appending the savedHype to our SOT, completing true
            self.entry.append(savedEntry)
            print("Saved hype successfully")
            completion(true)
        }
    }
    
//    func addEntryWith(titleText: String, bodyText: String, completion: @escaping (_ success: Bool) -> Void) {
//        let newEntry = Entry(titleText: titleText, bodyText: bodyText)
//        saveEntry(entry: newEntry) { (success) in
//            if success {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
//    }
//
//    func saveEntry(entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
//        let entryRecord = CKRecord(entry: entry)
//        privateDB.save(entryRecord) { (record, error) in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                completion(false)
//                return
//            }
//            guard let record = record,
//                let savedEntry = Entry(ckRecord: record)
//                else { completion(false); return }
//
//            self.entry.append(savedEntry)
//            print("entry saved successfully")
//            completion(true)
//        }
//    }
    
    func fetchEntries(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecord, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = foundRecord
                else { completion(false); return }
            
            let entries = record.compactMap( { Entry(ckRecord: $0) } )
            
            self.entry = entries
            print ("fetch successful")
            completion(true)
            
        }
    }
    
     func update(_ entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
        //step 3 - declaring the record we want to update and passing it into our operationg
        let recordToUpdate = CKRecord(entry: entry)
        //step 2 - create our operation, which requres an array of records to save
        let updateOperation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        // step4 - adjusting the properties for the operation
        updateOperation.savePolicy = .changedKeys
        updateOperation.qualityOfService = .userInitiated
        updateOperation.modifyRecordsCompletionBlock = { record, _, error in
            //handle error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
                
            }
            //step 5 - make sure our record that was updated matches the record we passed in, complete true it if does
            guard recordToUpdate == record?.first else {
                print("unexpected record was updated")
                completion(false);return
                
            }
            print("updated \(recordToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        //step1 - calling add method on our publicDB, which requires an operation
        privateDB.add(updateOperation)
    }
    
    
    func delete(_ entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
         //step2 - defining the operation, and passing in the array of recordIDs to delete
         let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [entry.ckRecordID])
        operation.savePolicy = .changedKeys
         //step 3 set properties of our operation
         operation.qualityOfService = .userInitiated
         operation.modifyRecordsCompletionBlock = { _, recordIds, error in
             //step 4 handle error
             if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                 completion(false)
                 return
             }
             //comparing the hype.ckRecordID that we wanted to delete to the RecordID that was deleted. if they match we complete true
             guard entry.ckRecordID == recordIds?.first else {
                 completion(false)
                 print("unexpected recordID was deleted")
                 return}
             
             print("successfully deleted hype from cloudkit")
             completion(true)
         }
         //step 1 - calling add on the publicDB, that requires an operation
         privateDB.add(operation)
     }
    
    func slowDelete(_ entry: Entry, completion: @escaping (Bool) -> Void) {
        privateDB.delete(withRecordID: entry.ckRecordID) { (recordID, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            if recordID != nil {
                guard let index = self.entry.firstIndex(of: entry) else {
                    completion(false); return}
                self.entry.remove(at: index)
                completion(true)
            }
        }
    }
}
