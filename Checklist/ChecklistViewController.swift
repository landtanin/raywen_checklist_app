//
//  ViewController.swift
//  Checklist
//
//  Created by Tanin on 13/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1000
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    if let label = cell.viewWithTag(1000) as? UILabel {
      
      switch(indexPath.row % 5) {
      case 0:
        label.text = "Take a job"
      case 1:
        label.text = "Watch a movie"
      case 2:
        label.text = "Code an app"
      case 3:
        label.text = "Walk the dog"
      case 4:
        label.text = "Study design patterns"
      default:
        label.text = "default case"
      }
      
    }
    
    return cell
  }
  
}

