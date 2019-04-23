//
//  Settings.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-15.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import Foundation

class Settings {
    static func badgeEnabled() -> Bool { return UserDefaults.standard.bool(forKey: "badgeEnabled") }

    static func setBadgeEnabled(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "badgeEnabled")
    }

    static func notificationSchedules() -> [Date] { return UserDefaults.standard.array(forKey: "notificationSchedules") as? [Date] ?? [Date]()
    }

    static func setNotificationSchedules(_ value: [Date]) {
        UserDefaults.standard.set(value, forKey: "notificationSchedules")
    }

    static func alarmSchedules() -> [Date] {return UserDefaults.standard.array(forKey: "notificationSchedules") as? [Date] ?? [Date]() }

    static func setAlarmSchedules(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "notificationSchedules")
    }
}
