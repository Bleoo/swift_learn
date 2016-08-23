//
//  HomePageVC.swift
//  TabBar_Navigation
//
//  Created by TDC on 16/8/18.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.title = "首页"
        view.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.textColor = UIColor.blueColor()
        label.text = "home"
        view.addSubview(label)
    }
}
