//
//  Places.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/8/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct PlacesConstant {
    static let placeNameKey = "placeName"
    static let placeCommentKey = "placePhone"
    static let recordTypeKey = "Place"
}

class Places {
    let placesName: String
    let placesComment: String
    let ckRecordID: CKRecord.ID
    
    init(placesName: String, placesComment:String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.placesName = placesName
        self.placesComment = placesComment
        self.ckRecordID = ckRecordID
    }
}

extension Places {
    convenience init?(ckRecord: CKRecord) {
        guard let placesName = ckRecord[PlacesConstant.placeNameKey] as? String,
            let placesComment = ckRecord[PlacesConstant.placeCommentKey] as? String
            else {return nil}
        self.init(placesName: placesName, placesComment: placesComment)
    }
}

extension CKRecord {
    convenience init(places: Places) {
        self.init(recordType: PlacesConstant.recordTypeKey, recordID: places.ckRecordID)
        self.setValue(places.placesName, forKey: PlacesConstant.placeNameKey)
        self.setValue(places.placesComment, forKey: PlacesConstant.placeCommentKey)
    }
}
