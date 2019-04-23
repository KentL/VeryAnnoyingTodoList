//
//  NotificationController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-22.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationController {
    static func scheduleNotificationOnTime(_ date: Date) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Todo Reminder", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Don't forget you have things to do!", arguments: nil)
        content.sound = UNNotificationSound.default

        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)

        let request = UNNotificationRequest(identifier: "TodoReminder\(DateHelper.hourMinuteString(date))", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
        if let theError = error {
            print(theError.localizedDescription)
            }
        }
    }

    static func cancelNotificationOnTime(_ date: Date) -> Void {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TodoReminder\(DateHelper.hourMinuteString(date))"])
    }
}
