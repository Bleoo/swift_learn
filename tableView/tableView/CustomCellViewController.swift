//
//  CustomCellViewController.swift
//  tableView
//
//  Created by TDC on 16/8/17.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class CustomCellViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabelView: UITableView!
    
    let initIdentifier = "CustemCell"
    
    override func viewDidLoad() {
        tabelView.registerNib(UINib(nibName: "CustomCellView", bundle: nil), forCellReuseIdentifier: initIdentifier)
        tabelView.dataSource = self
        tabelView.delegate = self
        //tabelView.rowHeight = UITableViewAutomaticDimension;
        //tabelView.estimatedRowHeight = 40.0; // 设置为一个接近“平均”行高的值
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(initIdentifier) as? CustomCellView
        if cell == nil {
            cell = CustomCellView(style: .Default, reuseIdentifier: initIdentifier)
            cell!.accessoryType = .None
        }
        cell?.cImage.image = UIImage(named: "ic_launcher.png")
        cell?.cLabel1.text = "Label1-\(indexPath.row)"
        cell?.cLabel2.text = "Label2-\(indexPath.row)"
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
}
