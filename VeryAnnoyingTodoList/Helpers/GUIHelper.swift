//
//  GUIHelper.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-15.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import Foundation
import UIKit

class GUIHelper {
    static func showToast(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.present(alert, animated: true)
        let duration: Double = 3

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }

    static func showYesOrNoAlert(controller: UIViewController, title: String, msg: String, yesHandler: ((_: UIAlertAction) -> Void)?, noHandler:  ((_: UIAlertAction) -> Void)?) {
        let refreshAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: yesHandler))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: noHandler))

        controller.present(refreshAlert, animated: true, completion: nil)
    }
}
