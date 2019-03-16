//
//  CoreDataStack.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-16.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {

    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.veryannoyingtodolist")
        storeURL = storeURL?.appendingPathComponent("veryannoyingtodolist.sqlite")
        return storeURL!
    }

}
class CoreDataStack {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSCustomPersistentContainer(name: "TodoItem")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    static var managedObjectContext: NSManagedObjectContext?
}
