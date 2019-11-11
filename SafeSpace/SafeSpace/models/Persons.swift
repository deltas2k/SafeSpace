//
//  Persons.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/8/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct PersonConstant {
    static let personNameKey = "personName"
    static let personPhoneKey = "personPhone"
    static let recordTypeKey = "Person"
}

class Persons {
    var peopleName: String
    var peoplePhone: String
    let ckRecordID: CKRecord.ID
    
    init(peopleName: String, peoplePhone:String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.peopleName = peopleName
        self.peoplePhone = peoplePhone
        self.ckRecordID = ckRecordID
    }
}

extension Persons {
    convenience init?(ckRecord: CKRecord) {
        guard let peopleName = ckRecord[PersonConstant.personNameKey] as? String,
            let peoplePhone = ckRecord[PersonConstant.personPhoneKey] as? String
            else {return nil}
        self.init(peopleName: peopleName, peoplePhone: peoplePhone, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(persons: Persons) {
        self.init(recordType: PersonConstant.recordTypeKey, recordID: persons.ckRecordID)
        self.setValue(persons.peopleName, forKey: PersonConstant.personNameKey)
        self.setValue(persons.peoplePhone, forKey: PersonConstant.personPhoneKey)
    }
}

extension Persons: Equatable {
    static func == (lhs: Persons, rhs: Persons) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
