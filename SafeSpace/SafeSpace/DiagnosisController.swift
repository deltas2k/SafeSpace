//
//  DiagnosisController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/9/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class DiagnosisController {
    static let sharedDiagnosis = DiagnosisController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.SafeSpace2").privateCloudDatabase
    var diagnosis: [Diagnosis] = []
    
    //MARK: - Create
    func saveDiagnosis(with diagTitle: String, diagDose: String, completion: @escaping (_ success: Bool) -> Void) {
        let newDiagnosis = Diagnosis(diagnosisTitle: diagTitle, diagnosisComment: diagDose)
        let diagRecord = CKRecord(diagnosis: newDiagnosis)
        privateDB.save(diagRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let record = record,
                let savedDiag = Diagnosis(ckRecord: record)
                else { completion(false); return }
            self.diagnosis.append(savedDiag)
            print("diagnosis saved Successfully")
            completion(true)
        }
    }
    
    func fetchDiagnosis(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: DiagnosisConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let records = foundRecords else {completion(false); return}
            let diagnosis = records.compactMap( {Diagnosis(ckRecord: $0)})
            self.diagnosis = diagnosis
            print("fetched diagnosis successfully")
            completion(true)
        }
    }
    
    func updateDiagnosis(_ diag: Diagnosis, completion: @escaping(_ Success: Bool) -> Void) {
        let diagToUpdate = CKRecord(diagnosis: diag)
        let operationDiag = CKModifyRecordsOperation(recordsToSave: [diagToUpdate], recordIDsToDelete: nil)
        operationDiag.savePolicy = .changedKeys
        operationDiag.qualityOfService = .userInteractive
        operationDiag.modifyRecordsCompletionBlock = {records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard diagToUpdate == records?.first else {
                print("unexpected record was updated")
                completion(false); return
            }
            print("Updated \(diagToUpdate.recordID) successfully in CloudKit")
                completion(true)
            }
        privateDB.add(operationDiag)
    }
    
    func delete(_ diag: Diagnosis, completion: @escaping(_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [diag.ckRecordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard diag.ckRecordID == recordIDs?.first else {
                completion(false)
                print("unexpected record deleted")
                return
            }
            print("Successfully deleted diagnosis from CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
}
