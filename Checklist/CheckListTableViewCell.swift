//
//  CheckListTableViewCell.swift
//  Checklist
//
//  Created by Tanin on 26/03/2019.
//  Copyright © 2019 landtanin. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {

  @IBOutlet weak var checkmarkLabel: UILabel!
  @IBOutlet weak var todoTextLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
