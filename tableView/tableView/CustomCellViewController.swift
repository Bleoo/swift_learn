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
    
    var contents = [String]()
    
    override func viewDidLoad() {
        contents.append("该方法使用于ios8.0后")
        contents.append("IOS8 不用计算Cell高度的TableView实现方案")
        contents.append("利用IOS8的新特性“self-sizing”，可以实现自动调整Cell高度的TableView。")
        contents.append("这个新特性，意味着View被Autolayout调整frame后，会自动拉伸和收缩SupView。具体到Cell,要求cell.contentView的四条边都与内部元素有约束关系。")
        contents.append("必须要完善Autolayout的所有约束才有效果，并适当调整约束以达到目标效果。")
        contents.append("关于Autolayout，可以通过addMissingConstraints自动添加后再进行调整。")
        contents.append("单个约束删除：select + backspace ")
        
        tabelView.registerNib(UINib(nibName: "CustomCellView", bundle: nil), forCellReuseIdentifier: initIdentifier)
        tabelView.dataSource = self
        tabelView.delegate = self
        // 以下为关键代码
        tabelView.estimatedRowHeight = 68.0; // 设置为一个接近“平均”行高的值
        tabelView.rowHeight = UITableViewAutomaticDimension; // 设置行高为自动调整高度
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(initIdentifier) as? CustomCellView
        if cell == nil {
            cell = CustomCellView(style: .Default, reuseIdentifier: initIdentifier)
            cell!.accessoryType = .None
        }
        cell?.cImage.image = UIImage(named: "ic_launcher.png")
        cell?.cLabel1.text = "Label-\(indexPath.row)"
        cell?.cLabel2.text = contents[indexPath.row]
        return cell!
    }

    // 当开启了自适应行高,该方法可以无需重写
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 68
//    }
    
}
