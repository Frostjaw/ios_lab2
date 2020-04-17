//
//  RoundedButton.swift
//  ios_lab2
//
//  Created by Frostjaw on 13/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
  
  enum Constants {
    static let buttonsCornerRadius = CGFloat(8)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButton()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupButton()
  }
  
  private func setupButton(){
    layer.cornerRadius = Constants.buttonsCornerRadius
    layer.masksToBounds = true
  }
}
