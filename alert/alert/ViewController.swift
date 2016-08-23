//
//  ViewController.swift
//  alert
//
//  Created by TDC on 16/8/15.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton()
        let button2 = UIButton()
        
        button1.frame = CGRectMake(50, 50, 100, 30)
        button1.setTitle("alert1", forState: .Normal)
        button1.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button1.addTarget(self, action: "doAlert1:", forControlEvents: .TouchUpInside)
        self.view.addSubview(button1)
        
        button2.frame = CGRectMake(50, 100, 100, 30)
        button2.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        button2.setTitle("alert2", forState: .Normal)
        button2.addTarget(self, action: "doAlert2:", forControlEvents: .TouchUpInside)
        self.view.addSubview(button2)

    }
    
    func doAlert1(sender: AnyObject){
        let alertController = UIAlertController(title: "alertTitle1", message: "alertMessage1", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "confirm", style: .Default, handler: nil)
        let cancelAction = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func doAlert2(sender: AnyObject){
        let alertController = UIAlertController(title: "alertTitle1", message: "alertMessage1", preferredStyle: .ActionSheet)
        let action1 = UIAlertAction(title: "action1", style: .Default, handler: nil)
        let action2 = UIAlertAction(title: "action2", style: .Default, handler: nil)
        let cancelAction = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }


}

