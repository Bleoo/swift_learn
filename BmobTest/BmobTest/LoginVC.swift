//
//  LoginVC.swift
//  BmobTest
//
//  Created by TDC on 16/9/5.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    
    @IBAction func loginAction(sender: AnyObject) {
        if let email = email_tf.text, password = password_tf.text {
            login(email, password: password)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "登录"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        email_tf.resignFirstResponder()
        password_tf.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func login(email: String, password: String){
        BmobUser.loginInbackgroundWithAccount(email, andPassword: password.MD5) { (user, error) -> Void in
            if user == nil {
                let toast = ToastView(text: "密码错误")
                self.view.addSubview(toast)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }


}