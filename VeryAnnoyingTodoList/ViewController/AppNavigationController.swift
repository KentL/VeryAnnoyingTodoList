//
//  AppNavigationController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-04-25.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    private var themedStatusBarStyle: UIStatusBarStyle?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? super.preferredStatusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
    }
}

extension AppNavigationController: Themed {
    func applyTheme(_ theme: AppTheme) {
        themedStatusBarStyle = theme.statusBarStyle
        setNeedsStatusBarAppearanceUpdate()

        navigationBar.barTintColor = theme.barBackgroundColor
        navigationBar.tintColor = theme.barForegroundColor
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.barForegroundColor
        ]
    }
}
