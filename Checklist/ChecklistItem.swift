//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Tanin on 16/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
  
  @objc var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
  
}
