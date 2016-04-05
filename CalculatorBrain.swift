//
//  CalculatorBrain.swift
//  Calculator-second-edition
//
//  Created by 杨威 on 16/4/3.
//  Copyright © 2016年 Muxing1991. All rights reserved.
//

import Foundation
class CalculatorBrain{
    //创建一个枚举 抽象操作数与操作符  枚举名、枚举值都首字母大写
    //Swift的特性 可以把枚举中的枚举值与数据关联起来
  enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case Unaryoperation(String, Double -> Double)
        case Binaryoperation(String, (Double, Double) -> Double)
    var description: String{
      get{
        switch self {
        case .Operand(let operand):
          return "\(operand)"
        case .Binaryoperation(let operation,_):
          return operation
        case .Unaryoperation(let operation,_):
          return operation
        }
      }
    }
    }
    //创建一个op数组 为了controler的清空 不private
   var opStack = [Op]()
    
   private var opsdic = [String:Op]()
    
    init(){
        //初始化操作字典
        opsdic["√"] = Op.Unaryoperation("√", sqrt)
        opsdic["+"] = Op.Binaryoperation("+", +)
        opsdic["−"] = Op.Binaryoperation("−", {$0 - $1})
        opsdic["×"] = Op.Binaryoperation("×", *)
        opsdic["÷"] = Op.Binaryoperation("÷", {$0 / $1})
        opsdic["sin"] = Op.Unaryoperation("sin", sin)
        opsdic["cos"] = Op.Unaryoperation("cos", cos)
        opsdic["π"] = Op.Operand(M_PI)
        opsdic["ᐩ/-"] = Op.Unaryoperation("-",{-$0})
        
    }
    
    //将操作数压入
    func pushOperand(operand: Double) -> (Double?, Double?, Double?){
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    //将操作符压入
    func pushOperation(operation: String) -> (Double?, Double?, Double?){
        if let dicoperation = opsdic[operation]{
            //能够在字典中找到的话 把对应的op压入
            opStack.append(dicoperation)
            return evaluate()
        }
        return (nil, nil, nil)
    }
    //输入一个op数组 返回结果与剩下的op数组
    private  func evaluate(ops: [Op]) ->(result: Double?, remainingOps: [Op],op1: Double?,op2: Double?){
        if !ops.isEmpty{
            var myops = ops
            let op = myops.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, myops, nil, nil)
            case .Unaryoperation(_, let operation):
                let evaluateone = evaluate(myops)
                if let num1 = evaluateone.result{
                    return (operation(num1),evaluateone.remainingOps,num1, nil)
                }
            case .Binaryoperation(_, let boperation):
                let evaluateone = evaluate(myops)
                if let num1 = evaluateone.result{
                    let evaluatetwo = evaluate(evaluateone.remainingOps)
                    if let num2 = evaluatetwo.result{
                        return (boperation(num2, num1),evaluatetwo.remainingOps, num2, num1)
                    }
                    else{
                      return (nil, evaluateone.remainingOps,nil,nil)
                  }
                }
            }
        }
        return (nil, [],nil, nil)
    }
    
    //重载
    func evaluate() -> (Double?, Double?, Double?){
        let (result, remainder ,op1, op2) = evaluate(opStack)
        print("opStack = \(opStack) result = \(result) remainder = \(remainder)")
        return (result, op1, op2)
    }
    
        
    
}
