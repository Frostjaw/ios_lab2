//
//  RoundedView.swift
//  ios_lab2
//
//  Created by Frostjaw on 13/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class RoundedView: UIView {
  
  enum Constants {
    static let viewCornerRadius = CGFloat(3)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView(){
    layer.cornerRadius = Constants.viewCornerRadius
  }
  
}
