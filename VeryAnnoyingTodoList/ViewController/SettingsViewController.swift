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

    var notificationSettingViewController: NotificationSettingViewController?
    @IBAction func showBadgeSwitchChanged(_ sender: UISwitch) {
        Settings.setBadgeEnabled(sender.isOn)
        if !sender.isOn {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        notificationSettingViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationSetting") as? NotificationSettingViewController
    }
}
