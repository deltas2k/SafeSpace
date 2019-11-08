//
//  SafetyPlan.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit





class RecognizeWarningSigns {
    let recognizeWSTitle: String
    let recognizeWSComment: String
    let ckRecordID: CKRecord.ID
    
    init(recognizeWSTitle: String, recognizeWSComment:String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.recognizeWSTitle = recognizeWSTitle
        self.recognizeWSComment = recognizeWSComment
        self.ckRecordID = ckRecordID
    }
}

class Activities {
    let activities: String
    let activitiesComment: String
    let ckRecordID: CKRecord.ID
    
    init(activities: String, activitiesComment:String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.activities = activities
        self.activitiesComment = activitiesComment
        self.ckRecordID = ckRecordID
    }
}

class Persons {
    let peopleName: String
    let peoplePhone: String
    let ckRecordID: CKRecord.ID
    
    init(peopleName: String, peoplePhone:String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.peopleName = peopleName
        self.peoplePhone = peoplePhone
        self.ckRecordID = ckRecordID
    }
}

class Places {
    let placesTitle: String
    let placesComment: String
    let ckRecordID: CKRecord.ID
    
    init(placesTitle: String, placesComment:String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.placesTitle = placesTitle
        self.placesComment = placesComment
        self.ckRecordID = ckRecordID
    }
}
