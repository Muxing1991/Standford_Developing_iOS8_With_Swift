//
//  ViewController.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/3/31.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
  
  
  @IBOutlet weak var display: UILabel!
  
  @IBOutlet weak var history: UILabel!
  
  var isTyping = false
  
  var brain = CalculatorBrain()
  
  //extra credit Undo
  //如果是输入中 就删除  如果不是输入中 就撤销上一次操作
  
  
 
  
  @IBAction func deleteDigit() {
    
    if isTyping{
      //删除display中显示的数字
      let displayDigit = display.text!
      let rest = displayDigit.characters.dropLast()
      if rest.count == 0 {
        display.text = "0"
        isTyping = false
        return
      }
      display.text = String(rest)
    }
    else {
      //不是输入中 撤销上一次操作 
      brain.undo()
      history.text = "history"
      displayValue = 0
      
    }
    
  }
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    if isTyping{
      enter() //把现在显示在display的数字压入栈
    }
    //let operationresult = brain.pushOperation(operation)
    brain.pushOperation(operation)
    
    
    //有结果的情况下
//    if let result = operationresult{
//      displayValue = result
//    }
//    else{
//      displayValue = nil
//    }
    display.text = brain.evaluateAndReportErrors()
    appendDescription()
    
  }
  
  
  
  
  func appendDescription(){
    history.text = brain.description + " = "
  }
  
  @IBAction func appendDigit(sender: UIButton) {
    
    let digit = sender.currentTitle!
    
    if isTyping{
      if digit == "." && display.text!.rangeOfString(".") != nil {
        return
      }
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
      if let  result = brain.pushOperand(value){
        displayValue = result
       
      }
    }
  }
  
  
  
  @IBAction func setVariableM() {
    brain.variableValue["M"] = displayValue
    //displayValue = brain.evaluate()
    display.text = brain.evaluateAndReportErrors()
  }
  
  
  @IBAction func clean() {
    brain.cleanAllData()
    history.text = "history"
    displayValue = 0
    
  }
  @IBAction func pushVariableM() {
    if isTyping{
      // 如果真在typing 把之前的数字压入
      enter()
    }
    brain.pushOperand("M")
  }
  var displayValue: Double?{
    // optional chaining
    get{
      
      return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
      //如果无法转换 将会返回nil 不会报错 这就是optional chaining  调用目标可能为空的属性 方法 下标
      
    }
    set{
//      display.text = newValue?.description ?? " "
      
      //当 newvalue为nil时 显示框为空 使用空合运算符 防止显示框缩小
      if let value = newValue{
        display.text = transFraction(value)
      }
      //print(newValue?.description)
      else {
        display.text = " "
      }
      
      isTyping = false
    }
    
  }

  func transFraction(input: Double) -> String {
    if input - round(input) != 0 {
      //是小数
      return String(format: "%.2f", input)
    }
    else{
      return String(format: "%.0f", input)
    }
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
        
//        if let result = brain.evaluate(){
//          displayValue = result
        display.text = brain.evaluateAndReportErrors()
          
        //}
        
      }
    }
  }
}

