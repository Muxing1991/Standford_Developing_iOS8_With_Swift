//
//  GraphsViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/4.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController {
  
  @IBOutlet weak var graph: Axes!{
    didSet{
      graph.addGestureRecognizer(UIPinchGestureRecognizer(target: graph, action: "pinching:"))
      graph.addGestureRecognizer(UIPanGestureRecognizer(target: graph, action: "panning:"))
    }
  }
  
}
