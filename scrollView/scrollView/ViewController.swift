//
//  ViewController.swift
//  scrollView
//
//  Created by TDC on 16/8/19.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var width = UIScreen.mainScreen().bounds.width
    var height = UIScreen.mainScreen().bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.frame = CGRectMake(0, 0, 100, 100)
        label.text = "主界面"
        label.center = CGPoint(x: width / 2, y: height / 2)
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

