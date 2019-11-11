//
//  Journal.swift
//  SafeSpace
//
//  Created by Matthew O'Connor on 11/7/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct EntryConstants {
    static let titleKey = "titleText"
    static let bodyKey = "bodyText"
    static let happyKey = "happinessBar"
    static let timestampKey = "timeStamp"
    static let recordTypeKey = "Entry"
}

class Entry {
    var titleText: String
    var bodyText: String
    var timestamp: Date
    var happinessBar: Int
    let ckRecordID: CKRecord.ID
    
    init(titleText: String, bodyText:String, happinessBar: Int, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.titleText = titleText
        self.bodyText = bodyText
        self.happinessBar = happinessBar
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let titleText = ckRecord[EntryConstants.titleKey] as? String,
            let bodyText = ckRecord[EntryConstants.bodyKey] as? String,
            let happyBar = ckRecord[EntryConstants.happyKey] as? Int,
            let timestamp = ckRecord[EntryConstants.timestampKey] as? Date
            else {return nil}
        self.init(titleText: titleText, bodyText: bodyText, happinessBar: happyBar, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordTypeKey, recordID: entry.ckRecordID)
        self.setValue(entry.titleText, forKey: EntryConstants.titleKey)
        self.setValue(entry.bodyText, forKey: EntryConstants.bodyKey)
        self.setValue(entry.happinessBar, forKey: EntryConstants.happyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
    
    
}
