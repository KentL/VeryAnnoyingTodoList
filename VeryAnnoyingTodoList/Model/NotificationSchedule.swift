//
//  NotificationSchedule.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-22.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import Foundation

class NotificationSchedule: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(time, forKey: "time")
        aCoder.encode(enabled, forKey: "enabled")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let time = aDecoder.decodeObject(forKey: "time") as! Date
        let enabled = aDecoder.decodeBool(forKey: "enabled")
        self.init(time: time, enabled: enabled)
    }

    var time: Date
    var enabled: Bool
    init(time:Date, enabled: Bool) {
        self.time = time
        self.enabled = enabled
    }


}
