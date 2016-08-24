//
//  ViewController.swift
//  Contacts
//
//  Created by TDC on 16/8/23.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

var contacts = [Contact]()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isModify = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts.append(Contact(image: "contacts.png", name: "leo liu", phone: "8888888"))
        contacts.append(Contact(image: "contacts.png", name: "哈哈", phone: "666666"))
        contacts.append(Contact(image: "contacts.png", name: "呵呵", phone: "123852963"))
        contacts.append(Contact(image: "contacts.png", name: "嘻嘻", phone: "18212349876"))
        // 设置navigationBar的左侧添加一个edit按钮
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
//        if isModify {
//            tableView.reloadData()
//            isModify = false
//        }
    }
    
    func getIsModify(isModify: Bool) -> Void {
        print("test delegate")
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell")
        let imageView = cell?.viewWithTag(101) as! UIImageView
        let nameLabel = cell?.viewWithTag(102) as! UILabel
        let phoneLabel = cell?.viewWithTag(103) as! UILabel
        
        let contact = contacts[indexPath.row]
        imageView.image = UIImage(named: contact.image!)
        nameLabel.text = contact.name
        phoneLabel.text = contact.phone
        
        return cell!
    }
    
    // 设置tableView的edit状态时有删除按钮,并可对其进行响应
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            contacts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // 界面是否进入edit状态
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // 设置tableView的编辑状态
        tableView.setEditing(editing, animated: animated)
    }
    
    // Segue跳转调用此处，用于传递参数
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newContact" {
            let newContactVC = segue.destinationViewController as! NewContactVC
            newContactVC.delegate = self
        }
    }
    
}

