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
  
  private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
    return TodoList.Priority(rawValue: index)
  }
  
  required init?(coder aDecoder: NSCoder) {
    todoList = TodoList()
    super.init(coder: aDecoder)
  }
  
  @IBAction func addItem(_ sender: UIBarButtonItem) {
    
    let newRowIndex = todoList.todoList(for: .medium).count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    
  }
  
  @IBAction func deleteItems(_ sender: Any) {
    if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
      for indexPath in selectedIndexPaths {
        
        if let priority = priorityForSectionIndex(indexPath.section) {
          let todos = todoList.todoList(for: priority)
          
          // TODO: This is wrong. Try delete row 0, 3, 4. Then edit the last remaining row, the text on the edit screen will be diffrent
          let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
          print("priority = \(priority.rawValue)")
          print("indexPath.row = \(indexPath.row)")
          print("todos.count - 1 = \(todos.count - 1)")
          print("rowToDelete = \(rowToDelete)")
          
          let item = todos[rowToDelete]
          print("item of rowToDelete = \(item.text)")
          todoList.remove(item, from: priority, at: rowToDelete)
        }
      }
      tableView.beginUpdates()
      tableView.deleteRows(at: selectedIndexPaths, with: .automatic)
      tableView.endUpdates()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = editButtonItem
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    tableView.setEditing(tableView.isEditing, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //    todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let priority = priorityForSectionIndex(section) {
      return todoList.todoList(for: priority).count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    // let item = todoList.todos[indexPath.row]
    if let priority = priorityForSectionIndex(indexPath.section) {
      let item = todoList.todoList(for: priority)[indexPath.row]
      configureText(for: cell, with: item)
      configureCheckmark(for: cell, with: item)
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if let priority = priorityForSectionIndex(indexPath.section) {
      
      let items = todoList.todoList(for: priority)
      let item = items[indexPath.row]
      todoList.remove(item, from: priority, at: indexPath.row)
      
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
  }
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    
    if let cell = cell as? CheckListTableViewCell {
      cell.todoTextLabel.text = item.text
    }
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.isEditing {
      return
    }
    if let cell = tableView.cellForRow(at: indexPath) {
      if let priority = priorityForSectionIndex(indexPath.section) {
        let items = todoList.todoList(for: priority)
        let item = items[indexPath.row]
        item.toggleChecked()
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
      }
    }
  }
  
  private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    
    guard let cell = cell as? CheckListTableViewCell else {
      return
    }
    
    if item.checked {
      cell.checkmarkLabel.text = "√"
    } else {
      cell.checkmarkLabel.text = ""
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "AddItemSegue" {
      
      if let addItemViewController = segue.destination as? ItemDetailViewController {
        addItemViewController.delegate = self
        addItemViewController.todoList = todoList
      }
      
    } else if segue.identifier == "EditItemSegue" {
      
      if let addItemViewController = segue.destination as? ItemDetailViewController {
        if let cell = sender as? UITableViewCell,
          let indexPath = tableView.indexPath(for: cell),
          let priority = priorityForSectionIndex(indexPath.section)
        {
          let items = todoList.todoList(for: priority)
          let item = items[indexPath.row]
          addItemViewController.itemToEdit = item
          addItemViewController.delegate = self
        }
      }
    }
    
  }
  
  override  func numberOfSections(in tableView: UITableView) -> Int {
    return TodoList.Priority.allCases.count
  }
  
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    
    let rowIndex = todoList.todoList(for: .medium).count - 1
    let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue )
    tableView.insertRows(at: [indexPath], with: .automatic)
    
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    
    for priority in TodoList.Priority.allCases {
      let currentList = todoList.todoList(for: priority)
      if let index = currentList.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: priority.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
    }
    
    navigationController?.popViewController(animated: true)
    
  }
  
}
