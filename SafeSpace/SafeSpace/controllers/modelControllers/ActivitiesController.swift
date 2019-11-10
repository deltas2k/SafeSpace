//
//  ActivitiesController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/10/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class ActivitesController {
    static let sharedActivities = ActivitesController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.SafeSpace2").privateCloudDatabase
    var activities: [Activities] = []
    
    //MARK: - Create
    func saveActivities(with activityTitle: String, activityComment: String, completion: @escaping (_ success: Bool) -> Void) {
        let newActivity = Activities(activities: activityTitle, activitiesComment: activityComment)
        let activityRecord = CKRecord(activities: newActivity)
        privateDB.save(activityRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let record = record,
                let savedActivity = Activities(ckRecord: record)
                else { completion(false); return }
            self.activities.append(savedActivity)
            print("Warning sign saved Successfully")
            completion(true)
        }
    }
    
    func fetchActivities(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ActivitiesConstant.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let records = foundRecords else {completion(false); return}
            let activities = records.compactMap( {Activities(ckRecord: $0)})
            self.activities = activities
            print("fetched warning sign successfully")
            completion(true)
        }
    }
    
    func updateActivities(_ activity: Activities, completion: @escaping(_ Success: Bool) -> Void) {
        let activityToUpdate = CKRecord(activities: activity)
        let operation = CKModifyRecordsOperation(recordsToSave: [activityToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard activityToUpdate == records?.first else {
                print("unexpected record was updated")
                completion(false); return
            }
            print("Updated \(activityToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func delete(_ activity: Activities, completion: @escaping(_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [activity.ckRecordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard activity.ckRecordID == recordIDs?.first else {
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
