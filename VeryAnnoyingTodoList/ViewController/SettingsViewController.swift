//
//  SettingsViewController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-14.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController {
    @IBOutlet weak var showBadgeSwitch: UISwitch!

    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var showBadgeLabel: UILabel!
    @IBOutlet weak var notificationSettingLabel: UILabel!

    @IBOutlet weak var darkModeSwitch: UISwitch!
    var notificationSettingViewController: NotificationSettingViewController?
    @IBAction func showBadgeSwitchChanged(_ sender: UISwitch) {
        Settings.setBadgeEnabled(sender.isOn)
        if !sender.isOn {
            UIApplication.shared.applicationIconBadgeNumber = 0
        } else {
            let managedContext = CoreDataStack.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoItem")

            do {
                let todoItems = try (managedContext.fetch(fetchRequest))
                UIApplication.shared.applicationIconBadgeNumber = todoItems.count
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    @IBAction func darkModeToggled(_ sender: UISwitch) {
        Settings.setDarkModeEnabled(sender.isOn)
        if sender.isOn {
            themeProvider.useTheme(.dark)
        } else {
            themeProvider.useTheme(.light)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        notificationSettingViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationSetting") as? NotificationSettingViewController
        self.tableView.tableFooterView = UIView()//Hide separator between empty cells
        self.showBadgeSwitch.isOn = Settings.badgeEnabled()
        self.darkModeSwitch.isOn = Settings.darkModeEnabled()

        setUpTheming()
    }
}

extension SettingsViewController: Themed {
    func applyTheme(_ theme: AppTheme) {

        self.tableView.backgroundColor = theme.backgroundColor
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = themeProvider.currentTheme.backgroundColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = themeProvider.currentTheme.textColor
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.superview?.backgroundColor = themeProvider.currentTheme.backgroundColor
        darkModeLabel.textColor = themeProvider.currentTheme.textColor
        showBadgeLabel.textColor = themeProvider.currentTheme.textColor
        notificationSettingLabel.textColor = themeProvider.currentTheme.textColor
    }
}
