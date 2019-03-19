//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Tanin on 19/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {
  
  @IBAction func cancelBtn(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addBtn(_ sender: Any) {
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
  }
    
}
