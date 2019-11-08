//
//  Diagnosis.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct DiagnosisConstants {
    static let diagTitleKey = "diagnosisTitle"
    static let diagCommentKey = "diagnosisComment"
    static let recordTypeKey = "Diagnosis"
}

class Diagnosis {
    var diagnosisTitle: String
    var diagnosisComment: String
    let ckRecordID: CKRecord.ID
    
    init(diagnosisTitle: String, diagnosisComment: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.diagnosisTitle = diagnosisTitle
        self.diagnosisComment = diagnosisComment
        self.ckRecordID = ckRecordID
    }
}

extension Diagnosis {
    convenience init?(ckRecord: CKRecord) {
        guard let diagTitle = ckRecord[DiagnosisConstants.diagTitleKey] as? String,
            let diagComment = ckRecord[DiagnosisConstants.diagCommentKey] as? String
            else {return nil}
        self.init(diagnosisTitle: diagTitle, diagnosisComment: diagComment)
    }
}

extension CKRecord {
    convenience init(diagnosis: Diagnosis) {
        self.init(recordType: DiagnosisConstants.recordTypeKey, recordID: diagnosis.ckRecordID)
        self.setValue(diagnosis.diagnosisTitle, forKey: DiagnosisConstants.diagTitleKey)
        self.setValue(diagnosis.diagnosisComment, forKey: DiagnosisConstants.diagCommentKey)
    }
}
