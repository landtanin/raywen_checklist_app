//
//  ViewController.swift
//  Checklist
//
//  Created by Tanin on 13/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  
  let todoList: TodoList
  
  required init?(coder aDecoder: NSCoder) {
    todoList = TodoList()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  @IBAction func addItem(_ sender: UIBarButtonItem) {
    
    let newRowIndex = todoList.todos.count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.todos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    let item = todoList.todos[indexPath.row]
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    todoList.todos.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    
  }
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    if let label = cell.viewWithTag(1000) as? UILabel {
      label.text = item.text
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = todoList.todos[indexPath.row]
      configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  // there is a bug here 
  private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    
    guard let checkMark = cell.viewWithTag(1001) as? UILabel else {
      return
    }
    
    if item.checked {
      checkMark.text = "√"
    } else {
      checkMark.text = ""
    }
    item.toggleChecked()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "AddItemSegue" {
      
      if let addItemViewController = segue.destination as? AddItemTableViewController {
        addItemViewController.delegate = self
        addItemViewController.todoList = todoList
      }
      
    } else if segue.identifier == "EditItemSegue" {
      
      if let addItemViewController = segue.destination as? AddItemTableViewController {
        if let cell = sender as? UITableViewCell,
          let indexPath = tableView.indexPath(for: cell) {
          let item = todoList.todos[indexPath.row]
          addItemViewController.itemToEdit = item
        }
      }
    }
    
  }
  
}

extension ChecklistViewController: AddItemTableViewControllerDelegate {
  func addItemViewControllerDidCancel(controller: AddItemTableViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func addItemViewController(controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    
    let rowIndex = todoList.todos.count
    todoList.todos.append(item)
    let indexPath = IndexPath(row: rowIndex, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    
  }
  
}
