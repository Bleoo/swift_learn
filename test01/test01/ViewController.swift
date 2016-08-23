//
//  ViewController.swift
//  test01
//
//  Created by TDC on 16/8/11.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var display: UILabel!
    
    var operateStack = Array<Double>()
    var operate = ""
    var result: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
           display.text = "\(newValue)"
        }
    }

    @IBAction func appedDigit(sender: UIButton) {
        if(operateStack.count == 1){
            display.text = ""
        }
        if let digit = sender.currentTitle {
            if(display.text! == "0"){
                display.text = ""
            }
            display.text = display.text! + digit
        }
    }

    @IBAction func operate(sender: UIButton) {
        operate = sender.currentTitle!
        enter()
    }
    
    func preOperate(doOperate: (Double, Double) -> Double){
        if operateStack.count == 2 {
            result = doOperate(operateStack.removeLast(), operateStack.removeLast());
            operateStack.append(result)
        }
    }
    
    @IBAction func enter() {
        operateStack.append(result)
        switch(operate){
        case "×": preOperate(){ $0 * $1 }
        default:
            break
        }
    }
    
}

