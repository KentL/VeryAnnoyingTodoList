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

    static func notificationSchedules() -> [NotificationSchedule] {
        do {
            if let data = UserDefaults.standard.data(forKey: "notificationSchedules") {
                let notificationSchedules = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [NotificationSchedule]
                return notificationSchedules
            }
        } catch {
            print("Exception when decoding: \(error) ")
        }
        return [NotificationSchedule]()

    }

    static func setNotificationSchedules(_ value: [NotificationSchedule]) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "notificationSchedules")
        } catch  {
            print("hmmm, some thing wrong when encoding ")
        }



    }
}
