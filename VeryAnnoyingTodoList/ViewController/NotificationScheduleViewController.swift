//
//  NotificationSettingViewController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-22.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationScheduleViewController: UITableViewController {

    var addNotificationViewController: AddNotificationViewController?
    var schedules = [NotificationSchedule]()
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(addNotificationViewController!, animated: true)
    }
    private func reloadTableView() {
        schedules = Settings.notificationSchedules()
        schedules.sort { (schedule1, schedule2) -> Bool in
            let hour1 = Calendar.current.component(.hour, from: schedule1.time)
            let hour2 = Calendar.current.component(.hour, from: schedule2.time)
            let minute1 = Calendar.current.component(.minute, from: schedule1.time)
            let minute2 = Calendar.current.component(.minute, from: schedule2.time)

            return hour1 < hour2 || ((hour1 == hour2) && (minute1 < minute2))
        }
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        addNotificationViewController = storyBoard.instantiateViewController(withIdentifier: "AddNotification") as? AddNotificationViewController
        NotificationCenter.default.addObserver(self, selector: #selector(tryAddNewSchedules(_:)), name: .ScheduleDatePicked, object: nil)

        self.tableView.tableFooterView = UIView()//Hide separator between empty cells
        reloadTableView()
        setUpTheming()
    }
    @objc func tryAddNewSchedules(_ notification: Notification) {
        if let newDate = notification.userInfo?[UserInfoKey.pickedDate] as? Date {
            var scheduledDates = Settings.notificationSchedules()
            if !scheduledDates.contains(where: { (schedules) -> Bool in
                return sameHourAndMinute(schedules.time,newDate)
            }) {
                // if it's never set, set it and reschedule notification
                scheduledDates.append(NotificationSchedule(time: newDate, enabled: true))
                Settings.setNotificationSchedules(scheduledDates)
                NotificationController.scheduleNotificationOnTime(newDate)
                reloadTableView()
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        let date = schedules[indexPath.row].time
        cell.timeLabel.text = toStringWithAMPM(date)
        cell.scheduleSwitch.isOn = schedules[indexPath.row].enabled
        cell.time = date
        return cell
    }
    private func toStringWithAMPM(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        return formatter.string(from: date)
    }
    
    private func sameHourAndMinute(_ date1: Date, _ date2: Date) -> Bool {
        let hour1 = Calendar.current.component(.hour, from: date1)
        let hour2 = Calendar.current.component(.hour, from: date2)
        let minute1 = Calendar.current.component(.minute, from: date1)
        let minute2 = Calendar.current.component(.minute, from: date2)
        return hour1 == hour2 && minute1 == minute2
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let dateToDelete = self.schedules[indexPath.row].time
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            NotificationController.cancelNotificationOnTime(dateToDelete)
            let scheduledDates = Settings.notificationSchedules()
            let newScheduleDates = scheduledDates.filter({ (date) -> Bool in
                return !self.sameHourAndMinute(date.time, dateToDelete)
            })
            Settings.setNotificationSchedules(newScheduleDates)
            self.reloadTableView()
        }

        return [delete]

    }

    
}

extension NotificationScheduleViewController: Themed {
    func applyTheme(_ theme: AppTheme) {

        self.tableView.backgroundColor = theme.backgroundColor
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = themeProvider.currentTheme.backgroundColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = themeProvider.currentTheme.textColor
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let scheduleCell = cell as? ScheduleTableViewCell {
            scheduleCell.contentView.superview?.backgroundColor = themeProvider.currentTheme.backgroundColor
            scheduleCell.timeLabel.textColor = themeProvider.currentTheme.textColor
        }
    }
}
