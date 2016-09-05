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
    
    let myList = ["我的日记本", "我关注的人", "关注我的人"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人中心"
        
        user_tv.dataSource = self
        user_tv.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        user_tv.reloadData()
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
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let loginSB = UIStoryboard(name: "Main", bundle:nil)
            let loginVC = loginSB.instantiateViewControllerWithIdentifier("LoginSB") as! LoginVC
            //presentViewController(loginVC, animated: true, completion: nil)
            navigationController?.pushViewController(loginVC, animated: true)
            break
        case 1:
            break
        case 2:
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



}