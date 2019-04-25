//
//  AppTabBarController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-25.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
    }
}

extension AppTabBarController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tabBar.barTintColor = theme.barBackgroundColor
        tabBar.tintColor = theme.barForegroundColor
    }
}
