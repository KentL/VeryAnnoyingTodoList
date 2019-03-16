//
//  SettingsViewController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-14.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var showBadgetCell: UITableViewCell!
    @IBOutlet weak var quietTimeCell: UITableViewCell!
    @IBOutlet weak var alarmCell: UITableViewCell!
    @IBOutlet weak var notificationCell: UITableViewCell!
    @IBAction func showBadgeSwitchChanged(_ sender: UISwitch) {
        Settings.setBadgeEnabled(sender.isOn)
        if !sender.isOn {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    @IBAction func NotificationSwitchedChanged(_ sender: UISwitch) {
        Settings.setNotificationEnabled(sender.isOn)
        if !sender.isOn {
            notificationCell.accessoryType = .none
        } else {
            notificationCell.accessoryType = .disclosureIndicator
        }
    }

    @IBAction func alarmSwitchChanged(_ sender: UISwitch) {
        Settings.setAlarmEnabled(sender.isOn)
        if !sender.isOn {
            alarmCell.accessoryType = .none
        } else {
            alarmCell.accessoryType = .disclosureIndicator
        }
    }

    @IBAction func quietTimeSwitchChange(_ sender: UISwitch) {
        Settings.setQuietTimeEnabled(sender.isOn)
        if !sender.isOn {
            quietTimeCell.accessoryType = .none
        } else {
            quietTimeCell.accessoryType = .disclosureIndicator
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
