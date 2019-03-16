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

    static func notificationEnabled() -> Bool { return UserDefaults.standard.bool(forKey: "notificationEnabled") }

    static func setNotificationEnabled(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "notificationEnabled")
    }

    static func alarmEnabled() -> Bool {return UserDefaults.standard.bool(forKey: "alarmEnabled") }

    static func setAlarmEnabled(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "alarmEnabled")
    }

    static func quietTimeEnabled() -> Bool { return UserDefaults.standard.bool(forKey: "quietTimeEnabled") }
    
    static func setQuietTimeEnabled(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "quietTimeEnabled")
    }
}
