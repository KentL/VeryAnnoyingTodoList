//
//  EditPageViewController.swift
//  VeryAnnoyingTodoList
//
//  Created by Kent Li on 2019-03-14.
//  Copyright © 2019 Kent Li. All rights reserved.
//

import UIKit
import CoreData

class EditPageViewController: UIViewController {

    var itemToEdit: NSManagedObject?
    
    @IBOutlet weak var contentView: UITextView!
    @IBAction func cancelButtonClicked(_ sender: Any) {
        let originalContent = (itemToEdit?.value(forKey: "content") as? String) ?? ""
        if contentView.text != originalContent{
            GUIHelper.showYesOrNoAlert(controller: self, title: "Cancel", msg: "Confirm to leave?", yesHandler: { (_) in
                self.cleanUp()
                self.navigationController?.popViewController(animated: true)
            }, noHandler: nil)
        }else {
            self.cleanUp()
            self.navigationController?.popViewController(animated: true)
        }

    }
    @IBAction func saveButtonOnClicked(_ sender: Any) {
        //TODO: save to local
        if contentView.text.isEmpty {
            GUIHelper.showToast(controller: self, message: "content can't be empty")
        } else {
            save(contentView.text)
            self.cleanUp()
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func save(_ content:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        if itemToEdit == nil {
            let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: managedContext)!
            itemToEdit = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        itemToEdit?.setValue(content, forKeyPath: "content")
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: .NewTodoItemSaved, object: self)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let item = itemToEdit{
            loadItemIntoView(item)
        }
    }

    private func loadItemIntoView(_ item: NSManagedObject) {
        if let content = item.value(forKey: "content") as? String {
            contentView.text = content
        }
    }
    private func cleanUp() {
        itemToEdit = nil
        contentView.text = ""
    }
}
