//
//  ViewController.swift
//  BmobTest
//
//  Created by TDC on 16/8/30.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //查找GameScore表
        let query = BmobQuery(className: "Diary")
        query.findObjectsInBackgroundWithBlock { (array, error) in
            for i in 0..<array.count{
                let obj = array[i] as! BmobObject
                let content = obj.objectForKey("content") as? String
                //打印玩家名
                print("playerName \(content)")
                //打印objectId,createdAt,updatedAt
                print("objectid   \(obj.objectId)")
                print("createdAt  \(obj.createdAt)")
                print("updatedAt  \(obj.updatedAt)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

