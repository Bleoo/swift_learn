//
//  notifyPageVC.swift
//  TabBar_Navigation
//
//  Created by TDC on 16/8/19.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class NotifyPageVC: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.title = "通知"
        view.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
        label.textColor = UIColor.blueColor()
        label.text = "notify"
        view.addSubview(label)
    }
}