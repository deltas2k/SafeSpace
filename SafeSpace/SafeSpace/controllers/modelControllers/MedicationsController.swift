//
//  MedicationsController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/10/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class MedicationsController {
    static let sharedMedications = MedicationsController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.SafeSpace2").privateCloudDatabase
    var medications: [Medications] = []
    
    //MARK: - Create
    func saveMedications(with drugName: String, drugDose: String, completion: @escaping (_ success: Bool) -> Void) {
        let newMedications = Medications(medName: drugName, medDosage: drugDose)
        let drugRecord = CKRecord(medication: newMedications)
        privateDB.save(drugRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let record = record,
                let savedDrug = Medications(ckRecord: record)
                else { completion(false); return }
            self.medications.append(savedDrug)
            print("Medication saved Successfully")
            completion(true)
        }
    }
    
    func fetchMedications(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: MedicationsConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let records = foundRecords else {completion(false); return}
            let medications = records.compactMap( {Medications(ckRecord: $0)})
            self.medications = medications
            print("fetched medication successfully")
            completion(true)
        }
    }
    
    func updateMedications(_ drug: Medications, completion: @escaping(_ Success: Bool) -> Void) {
        let drugToUpdate = CKRecord(medication: drug)
        let operationDrug = CKModifyRecordsOperation(recordsToSave: [drugToUpdate], recordIDsToDelete: nil)
        operationDrug.savePolicy = .changedKeys
        operationDrug.qualityOfService = .userInteractive
        operationDrug.modifyRecordsCompletionBlock = {records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard drugToUpdate == records?.first else {
                print("unexpected record was updated")
                completion(false); return
            }
            print("Updated \(drugToUpdate.recordID) successfully in CloudKit")
                completion(true)
            }
        privateDB.add(operationDrug)
    }
    
    func delete(_ drug: Medications, completion: @escaping(_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [drug.ckRecordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard drug.ckRecordID == recordIDs?.first else {
                completion(false)
                print("unexpected record deleted")
                return
            }
            print("Successfully deleted medication from CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
}
