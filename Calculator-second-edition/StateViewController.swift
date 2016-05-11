//
//  StateViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/11.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class StateViewController: UIViewController {
  var state = "hello world"{
    didSet{
      if state == " "{
        state = "hello world"
      }
      stateText?.text = state
    }
  }
  
  @IBOutlet weak var stateText: UITextView!{
    didSet{
      stateText.text = state
    }
  }
  override var preferredContentSize: CGSize {
    get{
      if stateText != nil && presentingViewController != nil{
        return stateText.contentSize
      }
      return super.preferredContentSize
    }
    set{
      super.preferredContentSize = newValue
    }
  }
}
