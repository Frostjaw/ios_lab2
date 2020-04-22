//
//  ViewWithShadow.swift
//  ios_lab2
//
//  Created by Frostjaw on 19/04/2020.
//  Copyright © 2020 Frostjaw. All rights reserved.
//

import UIKit

class ViewWithShadow: UIView {
  
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
  
  private func setupView() {
    addShadow(top: false, left: true, bottom: true, right: true, shadowRadius: 2.0)
  }
  
  func addShadow(top: Bool, left: Bool, bottom: Bool, right: Bool, shadowRadius: CGFloat = 2.0) {
    self.layer.shadowPath = nil
    
    self.layer.masksToBounds = false
    self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.layer.shadowRadius = shadowRadius
    self.layer.shadowOpacity = 0.4
    
    let path = UIBezierPath()
    var x: CGFloat = 0
    var y: CGFloat = 0
    var viewWidth = self.frame.width
    var viewHeight = self.frame.height
    
    if !top {
      y += shadowRadius + 1
    }
    if !bottom {
      viewHeight -= shadowRadius + 1
    }
    if !left {
      x += shadowRadius+1
    }
    if !right {
      viewWidth -= shadowRadius + 1
    }
    path.move(to: CGPoint(x: x, y: y))
    path.addLine(to: CGPoint(x: x, y: viewHeight))
    path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
    path.addLine(to: CGPoint(x: viewWidth, y: y))
    path.close()
    self.layer.shadowPath = path.cgPath
  }
  
  
  
}
