//
//  ViewController.swift
//  tableView
//
//  Created by TDC on 16/8/15.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var texts = [String](count: 10, repeatedValue: "defult")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    // 指定列数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }


    // 指定行数,必须实现
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }

    // 配置cell显示,必须实现
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let initIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(initIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: initIdentifier)
            cell!.accessoryType = .None
        }
        cell!.imageView?.image = UIImage(named: "ic_launcher.png")
        cell!.imageView?.layer.masksToBounds = true
        cell!.textLabel?.text = texts[indexPath.row] + "\(indexPath.row)"
        return cell!
    }

    // 选中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "clicked", message: "alertMessage\(indexPath.row)", preferredStyle: .Alert)
        let action1 = UIAlertAction(title: "OK", style: .Cancel){(action: UIAlertAction) -> Void in
            self.performSegueWithIdentifier("showCustomCellView", sender: nil)
        }
        alertController.addAction(action1)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 配置是否可edit
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // 配置edit左滑显示
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // 闭包形式
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete"){(action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            self.texts.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "here is pageHander title"
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "here is pageFooter title"
    }

}

