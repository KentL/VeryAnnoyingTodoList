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

    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UITextView!
    @IBAction func cancelButtonClicked(_ sender: Any) {
        let originalContent = (itemToEdit?.value(forKey: "content") as? String) ?? ""
        if contentView.text != originalContent{
            GUIHelper.showYesOrNoAlert(controller: self, title: "Cancel", msg: "Confirm to leave without saving?", yesHandler: { (_) in
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
        let managedContext = CoreDataStack.persistentContainer.viewContext
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
        buildKeyBoardToolBar()
        contentView.keyboardDismissMode = .onDrag

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }


    private func buildKeyBoardToolBar() {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolbar.barStyle = .default

        keyboardToolbar.items = [UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: #selector(clearContent))
        ]
        keyboardToolbar.sizeToFit()

        contentView.inputAccessoryView = keyboardToolbar
    }
    @objc private func clearContent() {
        contentView.text = ""
    }
    @objc func keyboardNotification(notification: NSNotification) {
        //https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.textViewBottomConstraint?.constant = 0.0
            } else {
                self.textViewBottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
