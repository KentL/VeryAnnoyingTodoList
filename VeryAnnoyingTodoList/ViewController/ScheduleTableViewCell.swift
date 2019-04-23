//
//  ScheduleTableViewCell.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-22.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    var time: Date?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scheduleSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            //NotificationController.scheduleNotificationOnTime(time!)
        } else {
            //NotificationController.cancelNotificationOnTime(time!)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
