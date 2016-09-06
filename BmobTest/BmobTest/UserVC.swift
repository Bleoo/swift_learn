//
//  UserVC.swift
//  BmobTest
//
//  Created by TDC on 16/9/5.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class UserVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var user_tv: UITableView!
    var logoutAlert: UIAlertController?
    
    let myList = ["我的日记本", "我关注的人", "关注我的人"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人中心"
        
        user_tv.dataSource = self
        user_tv.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        reLoadUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3    //设置Section数
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return myList.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        switch indexPath.section {
        case 0:
            let currentUser = BmobUser.currentUser()
            if currentUser == nil {
                cell.textLabel?.text = "未登录"
            } else {
                cell.textLabel?.text = currentUser.username
            }
            break
        case 1:
            cell.textLabel?.text = myList[indexPath.row]
            break
        case 2:
            cell.textLabel?.text = "退出"
            cell.textLabel?.textColor = UIColor.redColor()
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let mainSB = UIStoryboard(name: "Main", bundle:nil)
            let loginVC = mainSB.instantiateViewControllerWithIdentifier("LoginSB") as! LoginVC
            //presentViewController(loginVC, animated: true, completion: nil)
            navigationController?.pushViewController(loginVC, animated: true)
            break
        case 1:
            switch indexPath.row {
            case 0:
                let mainSB = UIStoryboard(name: "Main", bundle: nil)
                let diaryBooksVC = mainSB.instantiateViewControllerWithIdentifier("DiaryBooksSB") as! DiaryBooksVC
                navigationController?.pushViewController(diaryBooksVC, animated: true)
                break
            default:
                break
            }
            break
        case 2:
            logoutAction()
            break
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1;
    }

    func logoutAction(){
        if BmobUser.currentUser() != nil {
            if logoutAlert == nil {
                logoutAlert = UIAlertController(title: "提示", message: "确定退出吗？", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "退出", style: UIAlertActionStyle.Destructive) { (action) -> Void in
                    BmobUser.logout()
                    self.reLoadUserInfo()
                }
                logoutAlert!.addAction(cancelAction)
                logoutAlert!.addAction(confirmAction)
            }
            presentViewController(logoutAlert!, animated: true, completion: nil)
        } else {
            print("未登录")
        }
    }
    
    func reLoadUserInfo(){
        user_tv.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
    }

}