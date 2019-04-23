//
//  NotificationCode.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-15.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import Foundation

extension Notification.Name {
    //Local Journal Post Events
    static let NewTodoItemSaved = Notification.Name("NewTodoItemSaved")
    static let NotificationScheduleChanged = Notification.Name("NotificationScheduleChanged")
     static let ScheduleDatePicked = Notification.Name("ScheduleDatePicked")

}

enum UserInfoKey: String {
    case pickedDate
}

