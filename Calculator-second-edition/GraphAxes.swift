//
//  GraphAxes.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/9.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

protocol GraphDataSource: class {
  func myFunc(sender:UIView ,x: CGFloat) -> CGFloat?
}
@IBDesignable
class GraphAxes: Axes {
  //protocol类型的变量 用来与Controller链接
  weak var myFunc: GraphDataSource?
  
  var expression: String?
  
  var lab = UILabel()
    
  
//  override func drawRect(rect: CGRect) {
//    let myfirst = bezierPathforCurve()
//    myfirst.stroke()
//  }
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    let mypath = bezierPathforCurve()
    mypath.stroke()
    if let exp = expression{
      let x = axesCenter.x + 50
      let y = axesCenter.y - 50
      lab.frame = CGRect(x: x, y: y, width: 150, height: 30)
      lab.text = exp
      lab.sizeToFit()
      self.addSubview(lab)
      
    }
    
  }
  
  func bezierPathforCurve() -> UIBezierPath{
    let path = UIBezierPath()
    path.lineWidth = 1
    UIColor.blueColor().set()
    let startx = CGFloat(0)
    let endx = bounds.width
    path.moveToPoint(CGPoint(x: startx, y: axesCenter.y))
    var i = startx
    if myFunc != nil{
      while i <= endx {
        let iy = myFunc!.myFunc(self, x: transViewX2Num(i))
        if let y = iy{
          path.addLineToPoint(CGPoint(x: i, y: transNumY2View(y)))
          i += 1
        }
        else {
          i += 1
          path.moveToPoint(CGPoint(x: CGFloat(i), y: axesCenter.y))
          continue
        }
      }
    }
    return path
  }
  
  //把X轴的point转化成数字
  private func transViewX2Num(x: CGFloat) -> CGFloat{
    return (x - axesCenter.x) / pointsPerUnit
  }
  //把计算出的数字转换成对应的点
  private func transNumY2View(y: CGFloat) -> CGFloat{
    return axesCenter.y - y * pointsPerUnit
  }
  
  
}
