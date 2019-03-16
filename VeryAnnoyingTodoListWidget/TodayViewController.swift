//
//  TodayViewController.swift
//  VeryAnnoyingTodoListWidget
//
//  Created by Kent Li on 2019-03-14.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding{
    @IBOutlet weak var todoList: UITableView!
    var todoItems:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoList.delegate = self
        todoList.dataSource = self
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
//        todoList.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItemsAndReload()
    }
    func fetchItemsAndReload() {
        let managedContext = CoreDataStack.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoItem")

        do {
            todoItems = try (managedContext.fetch(fetchRequest))
            todoList.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
//    @objc func tableTapped(tap:UITapGestureRecognizer) {
//        let myAppUrl = NSURL(string: "com.kent.veryannoyingtodolist://open-from-widget")!
//        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
//            if (!success) {
//                // let the user know it failed
//            }
//        })
//    }
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 200)
        }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
         completionHandler(NCUpdateResult.newData)
    }
    
}


extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoItem = todoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCell", for: indexPath)
        cell.textLabel?.text = todoItem.value(forKeyPath: "content") as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myAppUrl = NSURL(string: "com.kent.veryannoyingtodolist://")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
    }


}
