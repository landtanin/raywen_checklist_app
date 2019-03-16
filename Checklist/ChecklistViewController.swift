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
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.todos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    if let label = cell.viewWithTag(1000) as? UILabel {
      
      label.text = todoList.todos[indexPath.row].text
      
    }
    configureCheckmark(for: cell, at: indexPath)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let cell = tableView.cellForRow(at: indexPath) {
      configureCheckmark(for: cell, at: indexPath)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  private func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
    if todoList.todos[indexPath.row].checked {
      cell.accessoryType = .none
    } else {
      cell.accessoryType = .checkmark
    }
    todoList.todos[indexPath.row].checked = !todoList.todos[indexPath.row].checked
    
  }
  
}

