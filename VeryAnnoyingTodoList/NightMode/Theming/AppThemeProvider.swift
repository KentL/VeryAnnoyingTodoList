//
//  AppThemeProvider.swift
//  Night Mode
//
//  Created by Michael on 01/04/2018.
//  Copyright © 2018 Late Night Swift. All rights reserved.
//

import UIKit

final class AppThemeProvider: ThemeProvider {
	static let shared: AppThemeProvider = .init()

	private var theme: SubscribableValue<AppTheme>

	var currentTheme: AppTheme {
		get {
			return theme.value
		}
		set {
			setNewTheme(newValue)
		}
	}

	init() {
        if Settings.darkModeEnabled() {
            theme = SubscribableValue<AppTheme>(value: .dark)
        } else {
            theme = SubscribableValue<AppTheme>(value: .light)
        }
	}

	private func setNewTheme(_ newTheme: AppTheme) {
		let window = UIApplication.shared.delegate!.window!!
		UIView.transition(
			with: window,
			duration: 0.3,
			options: [.transitionCrossDissolve],
			animations: {
				self.theme.value = newTheme
			},
			completion: nil
		)
	}

	func subscribeToChanges(_ object: AnyObject, handler: @escaping (AppTheme) -> Void) {
		theme.subscribe(object, using: handler)
	}

    func useTheme(_ theme: Theme) {
		currentTheme = theme
	}
}

extension Themed  {
	var themeProvider: AppThemeProvider {
		return AppThemeProvider.shared
	}
}
