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
  var model: ((CGFloat) -> CGFloat?)?
  
  
    
  
  
  func myFunc(sender: UIView, x: CGFloat) -> CGFloat? {
    if let funcModel = model{
      return funcModel(x)
    }
    return nil
  }
  
  @IBOutlet weak var myGraph: Axes!{
    didSet{
      myGraph.myFunc = self
    }
  }
  
  
  
}
