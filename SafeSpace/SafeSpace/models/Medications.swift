//
//  Medications.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct MedicationsConstants {
    static let medNameKey = "medicationTitle"
    static let medDosageKey = "medicationComment"
    static let recordTypeKey = "Medication"
}

class Medications {
    let medName: String
    let medDosage: String
    let ckRecordID: CKRecord.ID
    
    init(medName: String, medDosage:String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.medName = medName
        self.medDosage = medDosage
        self.ckRecordID = ckRecordID
    }
}

extension Medications {
    convenience init?(ckRecord: CKRecord) {
        guard let medName = ckRecord[MedicationsConstants.medNameKey] as? String,
            let medDosage = ckRecord[MedicationsConstants.medDosageKey] as? String
            else {return nil}
        self.init(medName: medName, medDosage: medDosage, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(medication: Medications) {
        self.init(recordType: MedicationsConstants.recordTypeKey, recordID: medication.ckRecordID)
        self.setValue(medication.medName, forKey: MedicationsConstants.medNameKey)
        self.setValue(medication.medDosage, forKey: MedicationsConstants.medDosageKey)
    }
}

extension Medications: Equatable {
    static func == (lhs: Medications, rhs: Medications) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
