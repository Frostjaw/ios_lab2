//
//  ViewWithBottomBorder.swift
//  ios_lab2
//
//  Created by Frostjaw on 20/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class ViewWithBottomBorder: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView(){
    self.translatesAutoresizingMaskIntoConstraints = false
    let bottomBorder = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    bottomBorder.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    bottomBorder.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(bottomBorder)
    bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
  }
}
