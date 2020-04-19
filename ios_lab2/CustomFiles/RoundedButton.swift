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
    static let buttonDefaultCornerRadius = CGFloat(8)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setCornerRadius(cornerRadius: Constants.buttonDefaultCornerRadius)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setCornerRadius(cornerRadius: Constants.buttonDefaultCornerRadius)
  }
  
  func setCornerRadius(cornerRadius: CGFloat){
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = true
  }
}
