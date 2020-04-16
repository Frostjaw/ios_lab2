//
//  CaseTableViewCell.swift
//  ios_lab2
//
//  Created by Frostjaw on 16/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class CaseTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var colorView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
}
