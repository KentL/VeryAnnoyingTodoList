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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        timePicker.setDate(Date(), animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        let pickedTime = timePicker.date
        NotificationCenter.default.post(name: .ScheduleDatePicked, object: self, userInfo: [UserInfoKey.pickedDate:pickedTime])
        self.dismiss(animated: true, completion: nil)
    }
}
