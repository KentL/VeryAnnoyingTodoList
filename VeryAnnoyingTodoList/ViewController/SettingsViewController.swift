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

    @IBOutlet weak var showBadgetCell: UITableViewCell!

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


    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        notificationSettingViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationSetting") as? NotificationSettingViewController
        self.tableView.tableFooterView = UIView()//Hide separator between empty cells
    }
}
