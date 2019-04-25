//
//  TodoListViewController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-14.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TodoListViewController: UIViewController {

    var todoItems:[NSManagedObject] = []
    var editPageViewController: EditPageViewController?
    var appDelegate: AppDelegate?

    @IBOutlet weak var todoList: UITableView!

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        openEditPageWithEmptyEntity()

    }
    private func openEditPageWithEmptyEntity() {
        editPageViewController?.itemToEdit = nil

        navigationController?.pushViewController(editPageViewController!, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        todoList.dataSource = self
        todoList.delegate = self
        todoList.tableFooterView = UIView()//Hide separator between empty cells
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchItemsAndReload), name: .NewTodoItemSaved, object: nil)

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        editPageViewController = storyBoard.instantiateViewController(withIdentifier: "EditPage") as? EditPageViewController
        appDelegate = UIApplication.shared.delegate as? AppDelegate

        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tableDoubleTapped))
        tap.numberOfTapsRequired = 2
        todoList.addGestureRecognizer(tap)

        setUpTheming()
    }

    @objc func tableDoubleTapped(tap:UITapGestureRecognizer) {
        openEditPageWithEmptyEntity()
    }

    @objc private func fetchItemsAndReload() {
        let managedContext = CoreDataStack.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoItem")

        do {
            todoItems = try (managedContext.fetch(fetchRequest))
            todoList.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItemsAndReload()
        updateBadge()
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoItem = todoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        cell.textLabel?.text = todoItem.value(forKeyPath: "content") as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editPageViewController?.itemToEdit = todoItems[indexPath.row]
        navigationController?.pushViewController(editPageViewController!, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let managedContext = CoreDataStack.persistentContainer.viewContext
            managedContext.delete(self.todoItems[indexPath.row])
            do {
                try managedContext.save() // <- remember to put this :)
            } catch {
                print("Could not save.")
            }
            self.todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateBadge()
        }

        return [delete]

    }
    private func updateBadge() {
        if Settings.badgeEnabled() {
            UIApplication.shared.applicationIconBadgeNumber = self.todoItems.count
        }
    }
}

extension TodoListViewController: Themed {
    func applyTheme(_ theme: AppTheme) {

        todoList.backgroundColor = theme.backgroundColor
        todoList.reloadData()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.superview?.backgroundColor = themeProvider.currentTheme.backgroundColor
       cell.textLabel?.textColor = themeProvider.currentTheme.textColor
    }
}
