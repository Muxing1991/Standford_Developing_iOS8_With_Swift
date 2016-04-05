//
//  ViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/3/31.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var display: UILabel!
  
  @IBOutlet weak var history: UILabel!
  
  var state = true
  
  var isTyping = false
  
  var brain = CalculatorBrain()
  
  
  @IBAction func deleteDigit() {
    
    //删除display中显示的数字
    let displayDigit = display.text!
    let rest = displayDigit.characters.dropLast()
    if rest.count == 0 {
      display.text = "0"
      return
    }
    display.text = String(rest)
    if !isTyping{
      //如果不是打字中 也要enter
      enter()
    }
    
  }
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    if isTyping{
      enter() //把现在显示在display的数字压入栈
    }
    let operationresult = brain.pushOperation(operation)
    
    if let result = operationresult.0{
      if let num1 = operationresult.1, let num2 = operationresult.2{
        appendhistory("\(num1) "+operation+" \(num2) = \(result)")
      }
      else if let num1 = operationresult.1{
        appendhistory(operation + "(\(num1)) = \(result)")
      }
      else {
        appendhistory("\(result)")
      }
      displayValue = result
    }
    
  }
  
  
  @IBAction func clean() {
    //恢复初始状态
    display.text = "0"
    history.text = "History"
    brain.opStack = []
  }
  
  func appendhistory(msg: String){
    history.text = msg + " "
  }
  
  @IBAction func appendDigit(sender: UIButton) {
    
    let digit = sender.currentTitle!
    
    if digit == "." {
      if display.text!.rangeOfString(".") != nil {
        return
      }
      
      
    }
    
    
    if isTyping {
      display.text = display.text! + digit
    }
    else {
      display.text = digit
      
      isTyping = true
    }
    
  }
  
  @IBAction func enter() {
    isTyping = false
    //下一次是新的输入
    if let value = displayValue{
      if let  result = brain.pushOperand(value).0{
        displayValue = result
      }
    }
    
    
    
    
    
    
  }
  func enter(input: Double){
    isTyping = false
    
    brain.pushOperand(input)
    
    
  }
  
  var displayValue: Double?{
    get{
      //如果显示的是nan not a number 会报错
      
      if display.text! == "nan" {
        return nil
      }
      else {
        return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
      }
    }
    set{
      if let value = newValue{
        //去除多余的小数
        if isFraction(newValue!){
          display.text = String(format:"%.2f", value)
        }
        else{
          display.text = String(format:"%.0f", value)
        }
        
      }
      
      isTyping = false
    }
  }
  func isFraction(input: Double) ->Bool{
    return input - round(input) != 0
  }
  
  @IBAction func turnNegativeorPositive() {
    if let value = displayValue{
      if isTyping{
        
        displayValue = -value
        //继续typing
        isTyping = true
      }
      else {
        //不是输入中 启用单目操作符模式
        brain.pushOperation("ᐩ/-")
        
        if let result = brain.evaluate().0{
          displayValue = result
          
          
        }
        
      }
    }
  }
}

