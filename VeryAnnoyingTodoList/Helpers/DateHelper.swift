//
//  DateHelper.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-22.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import Foundation

class DateHelper {
    static func hourMinuteString(_ date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = String(format: "%02d", Calendar.current.component(.minute, from: date))
        return  "\(hour):\(minute)"
    }
}
