//
//  CalculatorBrain.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/4/3.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import Foundation
class CalculatorBrain: CustomStringConvertible
{
  private enum Op: CustomStringConvertible
  {
    //制定算术符优先级
    case Operand(Double, Int)
    case BinaryOperation(String, Int, (Double, Double) -> Double)
    case UnaryOperation(String, Int, Double -> Double)
    case VariableValue(String, Int)
    case Constants(String, Int, Double)
    
    
    var description: String{
      get{
        switch self {
        case .BinaryOperation(let operation , _, _):
          return operation
        case .Constants(let symbol , _, _):
          return  symbol
        case .Operand(let value):
          return "\(value)"
        case .UnaryOperation(let operation , _, _):
          return operation
        case .VariableValue(let symbol, _):
          return symbol
        }
      }
    }
    
    
  }
  
  //创建一个Op数组 用来保存操作信息
  private var OpStack = [Op]()
  //创建一个操作符的字典
  private var OpDic = [String:Op]()
  //创建一个变量的字典
  var variableValue = [String:Double]()
  
  
  
  init(){
    //在初始化中 对字典进行初始化
    OpDic["+"] = Op.BinaryOperation("+", 1, +)
    OpDic["−"] = Op.BinaryOperation("−", 2, {$0 - $1})
    OpDic["×"] = Op.BinaryOperation("×", 3, *)
    OpDic["÷"] = Op.BinaryOperation("÷", 4, {$0 / $1})
    OpDic["cos"] = Op.UnaryOperation("cos", 0, cos)
    OpDic["sin"] = Op.UnaryOperation("sin", 0, sin)
    OpDic["√"] = Op.UnaryOperation("√", 0, sqrt)
    OpDic["π"] = Op.Constants("π", 0, M_PI)
    
  }
  
  //压进一个操作数
  func pushOperand(operand: Double) -> Double?{
    OpStack.append(Op.Operand(operand, 0))
    return evaluate()
  }
  
  func pushOperand(symbol: String) -> Double?{
    OpStack.append(Op.VariableValue(symbol, 0))
    return evaluate()
  }
  //压进一个操作符
  func pushOperation(operation: String) -> Double?{
    if let op = OpDic[operation]{
      OpStack.append(op)
      return evaluate()
    }
    return nil
    
  }
  var description: String{
    //只读的 OpStack 描述
    get{
      return descript(OpStack).msg
    }
    
  }
  private func descript(opStack: [Op]) -> (msg: String,rank: Int, remainingOps: [Op]){
    if !OpStack.isEmpty{
      var myops = opStack
      
      let op = myops.removeLast()
      switch op{
      case .UnaryOperation(let operation,let rank, _):
        let udescript = descript(myops)
        return (operation + " ( " + udescript.msg + " ) ",rank, udescript.remainingOps)
      case .Operand(let operand, let rank):
        return ("\(operand)",rank, myops)
      case .Constants(let symbol,let rank, _):
        return (symbol, rank, myops)
      case .VariableValue(let symbol, let rank ):
        return (symbol, rank, myops)
      case .BinaryOperation(let operation, let rank, _):
        let descriptNext = descript(myops)
        var num2 = descriptNext.msg
        let rank2 = descriptNext.rank
        let descriptNextNext = descript(descriptNext.remainingOps)
        var num1 = descriptNextNext.msg
        let rank1 = descriptNextNext.rank
        //根据优先级 决定是否 添加括号
        if rank == 1  {
          //加
          return (num1 + " " + operation + " " + num2 + " ", rank, descriptNextNext.remainingOps )
        }
        else if rank == 2 {
          // 减
          if rank2 == 1 || rank2 == 2 {
            return (num1 + " " + operation + "（ " + num2 + " ) ", rank, descriptNextNext.remainingOps )
          }
          else{
            return (" "+num1 + " " + operation + " " + num2 + " ", rank, descriptNextNext.remainingOps )
          }
        }
        else if rank == 3 {
          if rank1 == 1 || rank1 == 2 {
            num1 = " ( " + num1 + " ) "
          }
          else if rank2 == 1 || rank2 == 2 {
            num2 = " ( " + num2 + " ) "
          }
          return (num1 + operation + num2, rank, descriptNextNext.remainingOps )
        }
        else if rank == 4{
          if rank1 == 1 || rank1 == 2 {
            num1 = " ( " + num1 + " ) "
          }
          else if rank2 == 1 || rank2 == 2 || rank2 == 3{
            num2 = " ( " + num2 + " ) "
          }
          return (num1 + operation + num2, rank, descriptNextNext.remainingOps )
        }
      }
    }
    
    return (" ", 0, opStack)
  }
  
  //计算 递归
  private func evaluate(opStack:[Op]) -> (result: Double?,remainingOps: [Op]) {
    if !opStack.isEmpty{
      var myops = opStack
      print(OpStack)
      let op = myops.removeLast()
      switch op {
      case .Operand(let value, _):
        return (value, myops)
      case .UnaryOperation(_, _, let operation):
        let evaluateNext = evaluate(myops)
        if let value = evaluateNext.result{
          return (operation(value), evaluateNext.remainingOps)
        }
      case .BinaryOperation(_, _, let operation):
        let evaluateNext = evaluate(myops)
        if let num2 = evaluateNext.result{
          let evaluateNextNext = evaluate(evaluateNext.remainingOps)
          if let num1 = evaluateNextNext.result{
            return (operation(num1, num2), evaluateNextNext.remainingOps)
          }
        }
      case .Constants( _, _, let value):
        return (value, myops)
      case .VariableValue(let symbol, _):
        if let value = variableValue[symbol]{
          return (value, myops)
        }
        else {
          return (nil, myops)
        }
      }
    }
    return (nil, opStack)
  }
  //重载
  func evaluate() -> Double? {
    return evaluate(OpStack).result
  }
  
}

