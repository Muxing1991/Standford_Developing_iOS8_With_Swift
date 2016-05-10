//
//  GraphsViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/4.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController, GraphDataSource {
  //显示表达式的标签
  
    
  
  
  @IBOutlet weak var graph: GraphAxes!{
    didSet{
      graph.addGestureRecognizer(UIPinchGestureRecognizer(target: graph, action: "pinching:"))
      graph.addGestureRecognizer(UIPanGestureRecognizer(target: graph, action: "panning:"))
      graph.addGestureRecognizer(UITapGestureRecognizer(target: graph, action: "doubleTapping:"))
      graph.myFunc = self
      graph.expression = displayExpression()
    }
  }
  //var model: ((CGFloat) -> CGFloat?)?
  //修改model 改为Brain的program
  
  var model: AnyObject?{
    didSet{
      brain.program = model as! Array<String>
    }
  }
  
  
  
  
  
  
  private var brain = CalculatorBrain()
  
  
  func myFunc(sender: UIView, x: CGFloat) -> CGFloat? {
    if model != nil{
//      brain.program = model as! Array<String>
      brain.variableValue["M"] = Double(x)
      if let result = brain.evaluate(){
        return CGFloat(result)
      }
      return 0
    }
    return nil
  }
  func displayExpression() -> String?{
    //此时brain还是一个空的brain 问题在这里
    let discription = brain.description
    let disArray = discription.componentsSeparatedByString(",")
    for var str in disArray.reverse(){
      if str.containsString("M"){
       
        str.replaceRange(str.rangeOfString("M")!, with: "x")
        return   "Expression: y = " + str
      }
    }
    return nil
  }
  
    
  
  
}
