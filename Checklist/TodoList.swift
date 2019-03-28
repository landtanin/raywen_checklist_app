//
//  TodoList.swift
//  Checklist
//
//  Created by Tanin on 16/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import Foundation

class TodoList {
  
  enum Priority: Int, CaseIterable {
    case high, medium, low, no
  }
  
  private var highPriorityTodos: [ChecklistItem] = []
  private var mediumPriorityTodos: [ChecklistItem] = []
  private var lowPriorityTodos: [ChecklistItem] = []
  private var noPriorityTodos: [ChecklistItem] = []
  
  init() {
    
    let row0Item = ChecklistItem()
    let row1Item = ChecklistItem()
    let row2Item = ChecklistItem()
    let row3Item = ChecklistItem()
    let row4Item = ChecklistItem()
    let row5Item = ChecklistItem()
    let row6Item = ChecklistItem()
    let row7Item = ChecklistItem()
    let row8Item = ChecklistItem()
    let row9Item = ChecklistItem()
    
    row0Item.text = "Take a jog"
    row1Item.text = "Watch a movie"
    row2Item.text = "Code an app"
    row3Item.text = "Walk the dog"
    row4Item.text = "Study design patterns"
    row5Item.text = "Read a book"
    row6Item.text = "Learn Swift"
    row7Item.text = "Groceries"
    row8Item.text = "Go to gym"
    row9Item.text = "Relax"
    
    addTodo(row0Item, for: .medium)
    addTodo(row1Item, for: .medium)
    addTodo(row2Item, for: .high)
    addTodo(row3Item, for: .high)
    addTodo(row4Item, for: .high)
    addTodo(row5Item, for: .low)
    addTodo(row6Item, for: .low)
    addTodo(row7Item, for: .no)
    addTodo(row8Item, for: .medium)
    addTodo(row9Item, for: .medium)
    
  }
  
  func addTodo(_ item: ChecklistItem, for priority: Priority) {
    switch priority {
    case .high:
      highPriorityTodos.append(item)
    case .medium:
      mediumPriorityTodos.append(item)
    case .low:
      lowPriorityTodos.append(item)
    case .no:
      noPriorityTodos.append(item)
    }
  }
  
  func todoList(for priority: Priority) -> [ChecklistItem] {
    switch priority {
    case .high:
      return highPriorityTodos
    case .medium:
      return mediumPriorityTodos
    case .low:
      return lowPriorityTodos
    case .no:
      return noPriorityTodos
    }
  }
  
  func newTodo() -> ChecklistItem {
    let item = ChecklistItem()
    item.text = randomName()
    item.checked = true
    mediumPriorityTodos.append(item)
    return item
  }
  
  func move(item: ChecklistItem, to index: Int) {
//    guard let currentIndex = todos.firstIndex(of: item) else {
//      return
//    }
//    todos.remove(at: currentIndex)
//    todos.insert(item, at: index)
  }
  
  func remove(_ item: ChecklistItem, from priority: Priority, at index: Int) {
    switch priority {
    case .high:
      highPriorityTodos.remove(at: index)
    case .medium:
      let removedItem = mediumPriorityTodos.remove(at: index)
      print("removedItem = \(removedItem.text)")
    case .low:
      lowPriorityTodos.remove(at: index)
    case .no:
      noPriorityTodos.remove(at: index)
    }
  }
  
  private func randomName() -> String {
    let titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
    let randomNumber = Int.random(in: 0...4)
    return titles[randomNumber]
  }
  
}
