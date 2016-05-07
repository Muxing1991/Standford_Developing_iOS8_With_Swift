//
//  GraphsViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/4.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController, GraphDataSource {
  
  @IBOutlet weak var graph: Axes!{
    didSet{
      graph.addGestureRecognizer(UIPinchGestureRecognizer(target: graph, action: "pinching:"))
      graph.addGestureRecognizer(UIPanGestureRecognizer(target: graph, action: "panning:"))
      graph.addGestureRecognizer(UITapGestureRecognizer(target: graph, action: "doubleTapping:"))
    }
  }
  //var model: ((CGFloat) -> CGFloat?)?
  //修改model 改为Brain的program
  
  var model: AnyObject?
  
  private var brain = CalculatorBrain()
  
  
  func myFunc(sender: UIView, x: CGFloat) -> CGFloat? {
//    if let brainModel = model{
//      brain.program = brainModel as! Array<String>
//      brain.variableValue["M"] = Double(x)
//      if let result = brain.evaluate(){
//        return CGFloat(result)
//      }
//      return 0
//    }
//    return 0
    if model != nil{
      brain.program = model as! Array<String>
      brain.variableValue["M"] = Double(x)
      if let result = brain.evaluate(){
        return CGFloat(result)
      }
      return 0
    }
    return nil
  }
  
  @IBOutlet weak var myGraph: Axes!{
    didSet{
      myGraph.myFunc = self
    }
  }
  
  
  
}
