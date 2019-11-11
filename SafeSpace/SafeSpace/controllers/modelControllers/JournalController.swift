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
        let hypeRecord = CKRecord(entry: newEntry)
        privateDB.save(hypeRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let savedEntry = Entry(ckRecord: record)
                else { completion(false) ; return }
            self.entry.append(savedEntry)
            print("Saved hype successfully")
            completion(true)
        }
    }
    
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
        let recordToUpdate = CKRecord(entry: entry)
        let updateOperation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        updateOperation.savePolicy = .changedKeys
        updateOperation.qualityOfService = .userInteractive
        updateOperation.modifyRecordsCompletionBlock = { record, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
                
            }
            guard recordToUpdate == record?.first else {
                print("unexpected record was updated")
                completion(false);return
                
            }
            print("updated \(recordToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(updateOperation)
    }
    
    
    func delete(_ entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
         let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [entry.ckRecordID])
        operation.savePolicy = .changedKeys
         operation.qualityOfService = .userInitiated
         operation.modifyRecordsCompletionBlock = { _, recordIds, error in
             if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                 completion(false)
                 return
             }
             guard entry.ckRecordID == recordIds?.first else {
                 completion(false)
                 print("unexpected recordID was deleted")
                 return}
             
             print("successfully deleted hype from cloudkit")
             completion(true)
         }
         privateDB.add(operation)
     }
}
