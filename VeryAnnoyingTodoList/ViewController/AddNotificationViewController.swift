//
//  AddNotificationViewController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-22.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit

class AddNotificationViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
    }

    override func viewDidAppear(_ animated: Bool) {
        timePicker.setDate(Date(), animated: true)
    }

    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        let pickedTime = timePicker.date
        NotificationCenter.default.post(name: .ScheduleDatePicked, object: self, userInfo: [UserInfoKey.pickedDate:pickedTime])
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNotificationViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        timePicker.backgroundColor = theme.backgroundColor
        timePicker.setValue(theme.textColor, forKeyPath: "textColor")
    }
}
