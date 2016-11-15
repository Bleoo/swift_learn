//
//  ViewController.swift
//  SJson
//
//  Created by TDC on 16/10/19.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let jsonString = "{\"name\":\"qwer\",\"age\":18,\"sex\":2}";

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)! as NSData
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        let keys = json?.allKeys as! [String]
        
        
        let user = User()
        let mirror = Mirror(reflecting: user)
        for case let (label?, value) in mirror.children {
           for key in keys {
            if key == label {
                user.setValue(json?.objectForKey(key), forKey: key)
            }
            }
            print(user.name, user.age, user.sex)
        }
    }

}

