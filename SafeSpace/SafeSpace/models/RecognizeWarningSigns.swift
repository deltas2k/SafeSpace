//
//  RecognizeWarningSigns.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct RecognizeWSConstants {
    static let RWSTitleKey = "diagnosisTitle"
    static let RWSCommentKey = "diagnosisComment"
    static let recordTypeKey = "Diagnosis"
}

class RecognizeWS {
    var recognizeWSTitle: String
    var recognizeWSComment: String
    let ckRecordID: CKRecord.ID
    
    init(recognizeWSTitle: String, recognizeWSComment: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.recognizeWSTitle = recognizeWSTitle
        self.recognizeWSComment = recognizeWSComment
        self.ckRecordID = ckRecordID
    }
}

extension RecognizeWS {
    convenience init?(ckRecord: CKRecord) {
        guard let RWSTitle = ckRecord[RecognizeWSConstants.RWSTitleKey] as? String,
            let RWSComment = ckRecord[RecognizeWSConstants.RWSCommentKey] as? String
            else {return nil}
        self.init(recognizeWSTitle: RWSTitle, recognizeWSComment: RWSComment, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(recognizeWS: RecognizeWS) {
        self.init(recordType: RecognizeWSConstants.recordTypeKey, recordID: recognizeWS.ckRecordID)
        self.setValue(recognizeWS.recognizeWSTitle, forKey: RecognizeWSConstants.RWSTitleKey)
        self.setValue(recognizeWS.recognizeWSComment, forKey: RecognizeWSConstants.RWSCommentKey)
    }
}

extension RecognizeWS: Equatable {
    static func == (lhs: RecognizeWS, rhs: RecognizeWS) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
