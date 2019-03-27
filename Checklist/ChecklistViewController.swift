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
  var tableData: [[ChecklistItem?]?]!
  
  required init?(coder aDecoder: NSCoder) {
    todoList = TodoList()
    super.init(coder: aDecoder)
  }
  
  @IBAction func addItem(_ sender: UIBarButtonItem) {
    
    let newRowIndex = todoList.todos.count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    
  }
  
  @IBAction func deleteItems(_ sender: Any) {
    if let selectedRows = tableView.indexPathsForSelectedRows {
      var items = [ChecklistItem]()
      for indexPath in selectedRows {
        let item = todoList.todos[indexPath.row]
        items.append(item)
      }
      todoList.remove(items: items)
      tableView.beginUpdates()
      tableView.deleteRows(at: selectedRows, with: .automatic)
      tableView.endUpdates()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = editButtonItem
    tableView.allowsMultipleSelectionDuringEditing = true
    
    let sectionTitleCount = UILocalizedIndexedCollation.current().sectionTitles.count
    var allSections = [[ChecklistItem?]?](repeating: nil, count: sectionTitleCount) // create 26 sections
    var sectionNumber = 0
    let collation = UILocalizedIndexedCollation.current()
    for item in todoList.todos {
      sectionNumber = collation.section(for: item, collationStringSelector: #selector(getter: ChecklistItem.text))
      if allSections[sectionNumber] == nil {
        allSections[sectionNumber] = [ChecklistItem?]()
      }
      allSections[sectionNumber]!.append(item)
    }
    tableData = allSections
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    tableView.setEditing(tableView.isEditing, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData[section] == nil ? 0 : tableData[section]!.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    // let item = todoList.todos[indexPath.row]
    if let item = tableData[indexPath.section]?[indexPath.row] {
      configureText(for: cell, with: item)
      configureCheckmark(for: cell, with: item)
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    todoList.todos.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    
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
      let item = todoList.todos[indexPath.row]
      item.toggleChecked()
      configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
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
          let indexPath = tableView.indexPath(for: cell) {
          let item = todoList.todos[indexPath.row]
          addItemViewController.itemToEdit = item
          addItemViewController.delegate = self
        }
      }
    }
    
  }
  
  override  func numberOfSections(in tableView: UITableView) -> Int {
    return tableData.count
  }
  
  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return UILocalizedIndexedCollation.current().sectionTitles
  }
  
  override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return UILocalizedIndexedCollation.current().sectionTitles[section]
  }
  
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    
    let rowIndex = todoList.todos.count - 1
    let indexPath = IndexPath(row: rowIndex, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    
    if let index = todoList.todos.index(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated: true)
    
  }
  
}
