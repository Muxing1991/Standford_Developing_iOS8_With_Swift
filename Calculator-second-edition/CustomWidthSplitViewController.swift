//
//  CustomWidthSplitViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/7.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class CustomWidthSplitViewController: UISplitViewController {
  
  override var minimumPrimaryColumnWidth: CGFloat {
    get{
      return 460.0
    }
    set{
      
    }
  }
  
}
