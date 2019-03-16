//
//  AppDelegate.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-14.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Set badge to 0 when reinstall
        //https://stackoverflow.com/questions/23365024/badge-count-is-persisted-after-deleting-an-app-and-installing-it-again
        if  !UserDefaults.standard.bool(forKey: "notFirstTime") {
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
            } else {
                application.cancelAllLocalNotifications()
            }
            application.applicationIconBadgeNumber = 0
            UserDefaults.standard.set(true, forKey: "notFirstTime")
        }
        return true
    }



    // MARK: - Core Data Saving support

    func saveContext () {
        let context = CoreDataStack.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                /// You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

