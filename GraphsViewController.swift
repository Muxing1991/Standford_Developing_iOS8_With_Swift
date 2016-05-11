//
//  GraphsViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/4.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController, GraphDataSource, UIPopoverPresentationControllerDelegate {
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
//    if let brainModel = model{
//      brain.program = brainModel as! Array<String>
//  性能提高的关键就在这里 因为在segue 到 graph后 model是没有变化的 不能每次手势就转型一次 这样的效率会非常低 而这个版本用属性观察器 在model被赋值后 对brain这个私有属性进行赋值 这样在重新绘制中都不需要对model来转型了
    if model != nil{
      brain.variableValue["M"] = Double(x)
      if let result = brain.evaluate(){
        return CGFloat(result)
      }
      return nil
    }
    return nil
  }
  func displayExpression() -> String?{
    //此时brain还是一个空的brain 问题在这里
    let discription = brain.description
    let disArray = discription.componentsSeparatedByString(",")
    var str = disArray.reverse()[0]
    if str.containsString("M"){
      str = str.stringByReplacingOccurrencesOfString("M", withString: "x")
      return "Expression: y = " + str
    }
    return nil
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let id = segue.identifier{
      switch id{
      case "state":
        if let svc = segue.destinationViewController as? StateViewController{
          //获取这个segue目标
          if let spc = svc.popoverPresentationController{
            spc.delegate = self
          }
          svc.state = brain.description.stringByReplacingOccurrencesOfString(",", withString: "\n")  
        }
      default: break
      }
    }
  }
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.None
  }
}
