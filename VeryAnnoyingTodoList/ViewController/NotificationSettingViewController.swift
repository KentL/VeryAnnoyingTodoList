//
//  NotificationSettingViewController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-22.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationSettingViewController: UITableViewController {

    var addNotificationViewController: AddNotificationViewController?
    var dates = [Date]()
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        self.present(addNotificationViewController!, animated: true)
    }
    private func reloadTableView() {
        dates = Settings.notificationSchedules()
        dates.sort { (date1, date2) -> Bool in
            let str1 = hourMinuteString(date1)
            let str2 = hourMinuteString(date2)
            return str1 > str2
        }
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        addNotificationViewController = storyBoard.instantiateViewController(withIdentifier: "AddNotification") as? AddNotificationViewController
        NotificationCenter.default.addObserver(self, selector: #selector(tryAddNewSchedules(_:)), name: .ScheduleDatePicked, object: nil)
        reloadTableView()
    }
    @objc func tryAddNewSchedules(_ notification: Notification) {
        if let newDate = notification.userInfo?[UserInfoKey.pickedDate] as? Date {
            var scheduledDates = Settings.notificationSchedules()
            if !scheduledDates.contains(where: { (scheduledDate) -> Bool in
                return sameHourAndMinute(scheduledDate,newDate)
            }) {
                // if it's never set, set it and reschedule notification
                scheduledDates.append(newDate)
                Settings.setNotificationSchedules(scheduledDates)
                addNotification(newDate)
                reloadTableView()
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleTableViewCell", for: indexPath)
        let date = dates[indexPath.row]
        cell.textLabel?.text = hourMinuteString(date)
        return cell
    }
    private func hourMinuteString(_ date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = String(format: "%02d", Calendar.current.component(.minute, from: date))
        return  "\(hour):\(minute)"
    }
    private func sameHourAndMinute(_ date1: Date, _ date2: Date) -> Bool {
        let hour1 = Calendar.current.component(.hour, from: date1)
        let hour2 = Calendar.current.component(.hour, from: date2)
        let minute1 = Calendar.current.component(.minute, from: date1)
        let minute2 = Calendar.current.component(.minute, from: date2)
        return hour1 == hour2 && minute1 == minute2
    }
    private func addNotification(_ date: Date) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Todo Reminder", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Don't forget you have things to do!", arguments: nil)
        content.sound = UNNotificationSound.default

        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)

        let request = UNNotificationRequest(identifier: "TodoReminder\(hourMinuteString(date))", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let dateToDelete = self.dates[indexPath.row]
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TodoReminder\(self.hourMinuteString(dateToDelete))"])
            let scheduledDates = Settings.notificationSchedules()
            let newScheduleDates = scheduledDates.filter({ (date) -> Bool in
                return !self.sameHourAndMinute(date, dateToDelete)
            })
            Settings.setNotificationSchedules(newScheduleDates)
            self.reloadTableView()
        }

        return [delete]

    }

    
}
