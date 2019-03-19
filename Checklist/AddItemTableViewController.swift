//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Tanin on 19/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var addBarBtn: UIBarButtonItem!
  @IBOutlet weak var cancelBarBtn: UIBarButtonItem!
  
  @IBAction func cancelBtn(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addBtn(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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

extension AddItemTableViewController: UITextFieldDelegate {
  
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
