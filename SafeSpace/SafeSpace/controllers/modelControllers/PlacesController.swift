//
//  PlacesController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/10/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class PlacesController {
    static let sharedPlaces = PlacesController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.SafeSpace2").privateCloudDatabase
    var places: [Places] = []
    
    //MARK: - Create
    func savePlaces(with placeTitle: String, placeComment: String, completion: @escaping (_ success: Bool) -> Void) {
        let newPlace = Places(placesName: placeTitle, placesComment: placeComment)
        let placeRecord = CKRecord(places: newPlace)
        privateDB.save(placeRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let record = record,
                let savedPlace = Places(ckRecord: record)
                else { completion(false); return }
            self.places.append(savedPlace)
            print("Place saved Successfully")
            completion(true)
        }
    }
    
    func fetchPlaces(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PlacesConstant.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let records = foundRecords else {completion(false); return}
            let places = records.compactMap( {Places(ckRecord: $0)})
            self.places = places
            print("fetched warning sign successfully")
            completion(true)
        }
    }
    
    func updatePlaces(_ place: Places, completion: @escaping(_ Success: Bool) -> Void) {
        let placeToUpdate = CKRecord(places: place)
        let operation = CKModifyRecordsOperation(recordsToSave: [placeToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard placeToUpdate == records?.first else {
                print("unexpected record was updated")
                completion(false); return
            }
            print("Updated \(placeToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func delete(_ place: Places, completion: @escaping(_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [place.ckRecordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard place.ckRecordID == recordIDs?.first else {
                completion(false)
                print("unexpected record deleted")
                return
            }
            print("Successfully deleted place from CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
}
