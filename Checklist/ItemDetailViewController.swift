//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Tanin on 19/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
  
  weak var delegate: ItemDetailViewControllerDelegate?
  weak var todoList: TodoList?
  weak var itemToEdit: ChecklistItem?
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var addBarBtn: UIBarButtonItem!
  @IBOutlet weak var cancelBarBtn: UIBarButtonItem!
  
  @IBAction func cancelBtn(_ sender: Any) {

    delegate?.itemDetailViewControllerDidCancel(controller : self)
  }
  
  @IBAction func addBtn(_ sender: Any) {
  
    if let item = itemToEdit, let text = textField.text {
      item.text = text
      delegate?.itemDetailViewController(controller: self, didFinishEditing: item)
    } else {
      if let item = todoList?.newTodo() {
        if let text = textField.text {
          item.text = text
        }
        item.checked = false
        delegate?.itemDetailViewController(controller: self, didFinishAdding: item)
      }
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      addBarBtn.isEnabled = true
    }
    navigationItem.largeTitleDisplayMode = .never
    textField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // This simulate a tap on textField which brings up the keyboard
    textField.becomeFirstResponder()
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
    
}

extension ItemDetailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // This will dismiss the keyboard
    textField.resignFirstResponder()
    return false
  }
 
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let oldText = textField.text,
          let stringRange = Range(range, in: oldText) else {
        return false
    }
    
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    if newText.isEmpty {
      addBarBtn.isEnabled = false
    } else {
      addBarBtn.isEnabled = true
    }
    
    return true
    
  }
  
}
