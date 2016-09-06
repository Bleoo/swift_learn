//
//  CreateBookVC.swift
//  BmobTest
//
//  Created by TDC on 16/9/6.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class CreateBookVC: UIViewController {

    @IBOutlet weak var subject_tf: UITextField!
    @IBOutlet weak var descript_tv: UITextView!
    @IBOutlet weak var unlockTime_tf: UITextField!
    @IBOutlet weak var bookPic_img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descript_tv.layer.borderColor = UIColor.lightGrayColor().CGColor
        descript_tv.layer.borderWidth = 0.6
        descript_tv.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}