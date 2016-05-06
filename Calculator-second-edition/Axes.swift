//
//  Axes.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/5/4.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit
@IBDesignable
class Axes: UIView {
  
  var axesCenter = CGPoint(x: 0, y: 0) {
    didSet{
      setNeedsDisplay()
    }
  }
  override var bounds: CGRect{
    didSet{
      let x = bounds.width / 2
      let y = bounds.height / 2
      axesCenter = CGPoint(x: x, y: y)
    }
  }
  
  var color: UIColor = UIColor.blackColor(){
    didSet{
      setNeedsLayout()
    }
  }
  var scale:CGFloat = 1{
    didSet{
      setNeedsDisplay()
    }
  }
  var pointsPerUnit: CGFloat = 50{
    didSet{
      setNeedsDisplay()
    }
  }
  
  override func drawRect(rect: CGRect) {
    //axesCenter = convertPoint(center, toView: superview)
    let axes = AxesDrawer(color: color, contentScaleFactor: scale)
    axes.drawAxesInRect(bounds, origin: axesCenter, pointsPerUnit: pointsPerUnit)
    let myfirst = bezierPathforCurve()
    myfirst.stroke()
  }
  func pinching(recognizer: UIPinchGestureRecognizer){
    if recognizer.state == .Changed{
      scale *= recognizer.scale
      pointsPerUnit *= recognizer.scale
      recognizer.scale = 1
    }
  }
  func panning(recognizer: UIPanGestureRecognizer){
    if recognizer.state == .Changed{
      let tran = recognizer.translationInView(self)
      let xpoint = axesCenter.x + tran.x
      let ypoint = axesCenter.y + tran.y
      axesCenter = CGPoint(x: xpoint, y: ypoint)
      recognizer.setTranslation(CGPointZero, inView: self)
    }
  }
  func doubleTapping(recognizer: UITapGestureRecognizer){
        recognizer.numberOfTapsRequired = 2
        if recognizer.state == .Ended{
        axesCenter = recognizer.locationInView(self)
        recognizer.accessibilityActivationPoint = CGPointZero
       
      
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
    while i <= endx {
      let iy = sin(transViewX2Num(i))
      path.addLineToPoint(CGPoint(x: i, y: transNumY2View(iy)))
      i += 1
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
