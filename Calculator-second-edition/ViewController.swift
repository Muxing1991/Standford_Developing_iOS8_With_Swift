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
    
    var isTyping = false
    //类初始化的时候 isTyping为false
    
    //声明一个栈来存数字
    //var digitStack: Array<Double> = Array<Double>()
    //var digitStack = Array<Double>()
    
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
      
      
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if isTyping{
            enter() //把现在显示在display的数字压入栈
        }
//        switch operation {
//        case "+": operateDigit(operation){ $0 + $1 }
//        case "−": operateDigit(operation){ $0 - $1 }
//        case "×": operateDigit(operation){ $0 * $1 }
//        case "÷": operateDigit(operation){ $0 / $1 }
//        case "√": operateDigit(operation){sqrt($0)}
//        case "sin": operateDigit(operation){sin($0)}
//        case "cos": operateDigit(operation){cos($0)}
//        case "π":  
//            enter(M_PI)//如果是pi就直接压入
//        default: break
//        }
        let operationresult = brain.pushOperation(operation)
//         if let result =  brain.pushOperation(operation).0{
//            displayValue = result
//           
//        }
        if let result = operationresult.0{
            if let num1 = operationresult.1, let num2 = operationresult.2{
                appendhistory("\(num1) "+operation+" \(num2)")
            }
            else if let num1 = operationresult.1{
                appendhistory(operation + "(\(num1))")
            }
            else {
                appendhistory("\(result)")
            }
            displayValue = result
        }
        
    }
//    func operateDigit(flag: String, operation: (Double,Double) -> Double){
//        if(digitStack.count>=2){
//            let num2 = digitStack.removeLast()
//            let num1 = digitStack.removeLast()
//            displayValue = operation(num1,num2)
//            enter()
//            appendhistory("\(num1) "+flag+" \(num2)")
//        }
//        
//        
//    }
    
    
    @IBAction func clean() {
        //恢复初始状态
        //digitStack = []
        display.text = "0"
        history.text = "History"
        brain.opStack = []
    }
//    private func operateDigit(flag: String,operation: (Double) -> Double){
//        if(digitStack.count>=1){
//            let num = digitStack.removeLast()
//            displayValue = operation(num)
//            enter()
//            appendhistory(flag + "(\(num))")
//        }
//        
//    }

    func appendhistory(msg: String){
        history.text = msg + " "
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        
        var digit = sender.currentTitle!
     
        if digit == "." {
            if display.text!.rangeOfString(".") != nil {
                return
            }
//            else {
//                digit = display.text! + "."
//            }
          
            
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
        //digitStack.append(displayValue)
       if let  result =  brain.pushOperand(displayValue).0{
            displayValue = result
        }
        
        //print("digitStack = \(digitStack)")
        //print("hello world")
        
        
        
    }
    func enter(input: Double){
        isTyping = false
        //digitStack.append(input)
        brain.pushOperand(input)
        //print("digitStack = \(digitStack)")
      
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            let result = String(format: "%.2f", newValue)
            display.text = result
            
            isTyping = false
        }
    }
    
}

