//
//  WarningSignsController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/10/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class WarningSignsController {
    static let sharedWS = WarningSignsController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.SafeSpace2").privateCloudDatabase
    var recognizeWS: [RecognizeWS] = []
    
    //MARK: - Create
    func saveWarningSigns(with wsTitle: String, wsComment: String, completion: @escaping (_ success: Bool) -> Void) {
        let newWarningSign = RecognizeWS(recognizeWSTitle: wsTitle, recognizeWSComment: wsComment)
        let warningSignRecord = CKRecord(recognizeWS: newWarningSign)
        privateDB.save(warningSignRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let record = record,
                let savedWS = RecognizeWS(ckRecord: record)
                else { completion(false); return }
            self.recognizeWS.append(savedWS)
            print("Warning sign saved Successfully")
            completion(true)
        }
    }
    
    func fetchWarningSign(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecognizeWSConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let records = foundRecords else {completion(false); return}
            let warningSign = records.compactMap( {RecognizeWS(ckRecord: $0)})
            self.recognizeWS = warningSign
            print("fetched warning sign successfully")
            completion(true)
        }
    }
    
    func updateWarningSign(_ warn: RecognizeWS, completion: @escaping(_ Success: Bool) -> Void) {
        let warningSignToUpdate = CKRecord(recognizeWS: warn)
        let operation = CKModifyRecordsOperation(recordsToSave: [warningSignToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard warningSignToUpdate == records?.first else {
                print("unexpected record was updated")
                completion(false); return
            }
            print("Updated \(warningSignToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func delete(_ warn: RecognizeWS, completion: @escaping(_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [warn.ckRecordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard warn.ckRecordID == recordIDs?.first else {
                completion(false)
                print("unexpected record deleted")
                return
            }
            print("Successfully deleted warning sign from CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
}

