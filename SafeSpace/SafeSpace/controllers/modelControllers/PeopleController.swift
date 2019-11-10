//
//  PeopleController.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/10/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class PersonController {
    static let sharedPeople = PersonController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.SafeSpace2").privateCloudDatabase
    var persons: [Persons] = []
    
    //MARK: - Create
    func savePerson(with personTitle: String, personNumber: String, completion: @escaping (_ success: Bool) -> Void) {
        let newPerson = Persons(peopleName: personTitle, peoplePhone: personNumber)
        let personRecord = CKRecord(persons: newPerson)
        privateDB.save(personRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let record = record,
                let savedPerson = Persons(ckRecord: record)
                else { completion(false); return }
            self.persons.append(savedPerson)
            print("Person saved Successfully")
            completion(true)
        }
    }
    
    func fetchPersons(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PersonConstant.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard let records = foundRecords else {completion(false); return}
            let person = records.compactMap( {Persons(ckRecord: $0)})
            self.persons = person
            print("fetched person successfully")
            completion(true)
        }
    }
    
    func updatePerson(_ person: Persons, completion: @escaping(_ Success: Bool) -> Void) {
        let personToUpdate = CKRecord(persons: person)
        let operation = CKModifyRecordsOperation(recordsToSave: [personToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard personToUpdate == records?.first else {
                print("unexpected record was updated")
                completion(false); return
            }
            print("Updated \(personToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func delete(_ person: Persons, completion: @escaping(_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [person.ckRecordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false); return
            }
            guard person.ckRecordID == recordIDs?.first else {
                completion(false)
                print("unexpected record deleted")
                return
            }
            print("Successfully deleted Person from CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
}
