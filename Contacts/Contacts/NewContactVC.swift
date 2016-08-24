//
//  NewContactVC.swift
//  Contacts
//
//  Created by TDC on 16/8/24.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

public protocol BDelegate {
    func getIsModify(isModify: Bool) -> Void
}

typealias TestBlock = (String)->()

class NewContactVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    var delegate: BDelegate?
    
    var blo: TestBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveNewContact(sender: AnyObject) {
        let name = nameTF.text
        let phone = phoneTF.text
        if name == nil || name == ""{
            let alert = UIAlertController(title: "兄弟", message: "姓名都不写么", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "我是傻逼", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(alertAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if phone == nil || phone == ""{
            let alert = UIAlertController(title: "兄弟", message: "号码都没有存来做什么", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "我是傻逼", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(alertAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        contacts.append(Contact(image: "contacts", name: name!, phone: phone!))
        // 在导航控制器中取去上一个VC并可以对其属性进行操作，实现传值
        //let mainVC = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2] as! ViewController
        //mainVC.isModify = true
        
        // 代理及block都属于回调，代理类似接口，而block类似方法块
        self.delegate?.getIsModify(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
}