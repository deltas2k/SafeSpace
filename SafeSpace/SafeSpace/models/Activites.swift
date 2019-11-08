//
//  Activites.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/8/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct ActivitiesConstant {
    static let activityTitleKey = "activityTitle"
    static let activityCommentKey = "activityComment"
    static let recordTypeKey = "Activity"
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

extension Activities {
    convenience init?(ckRecord: CKRecord) {
        guard let activities = ckRecord[ActivitiesConstant.activityTitleKey] as? String,
            let activitiesComment = ckRecord[ActivitiesConstant.activityCommentKey] as? String
            else {return nil}
        self.init(activities: activities, activitiesComment: activitiesComment)
    }
}

extension CKRecord {
    convenience init(activities: Activities) {
        self.init(recordType: ActivitiesConstant.recordTypeKey, recordID: activities.ckRecordID)
        self.setValue(activities.activities, forKey: ActivitiesConstant.activityTitleKey)
        self.setValue(activities.activitiesComment, forKey: ActivitiesConstant.activityCommentKey)
    }
}
