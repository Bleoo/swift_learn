//
//  ViewController.swift
//  BmobTest
//
//  Created by TDC on 16/8/30.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var diarys_tv: UITableView!
    var refreshControl = UIRefreshControl()
    
    let dateFormatter = NSDateFormatter()
    
    var diarys = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开以刷新")
        diarys_tv.addSubview(refreshControl)
        
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        //查找表
        queryAll()
        
        //User.queryUserById("HUwb4449")
        //DiaryBook.queryBooksByUserId("HUwb4449")
        diarys_tv.registerNib(UINib(nibName: "DiaryCell", bundle: nil), forCellReuseIdentifier: "DiaryCell")
        
        diarys_tv.dataSource = self
        diarys_tv.delegate = self
        diarys_tv.estimatedRowHeight = 80.0; // 设置为一个接近“平均”行高的值
        diarys_tv.rowHeight = UITableViewAutomaticDimension; // 设置行高为自动调整高度
    }
    
    func queryAll() {
        //查找表
        let query = BmobQuery(className: "Diary")
        query.includeKey("user,book")
        query.findObjectsInBackgroundWithBlock { (array, error) in
            for obj in array{
                let diary = Diary.convert(obj as! BmobObject)
                self.diarys.append(diary)
            }
            self.diarys_tv.reloadData()
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell") as? DiaryCell
        if cell == nil {
            cell = DiaryCell(style: .Default, reuseIdentifier: "DiaryCell")
        }
        let diary = diarys[indexPath.row]
        cell?.user_btn.setTitle(diary.user?.username, forState: UIControlState.Normal)
        cell?.book_btn.setTitle(diary.book?.subject, forState: UIControlState.Normal)
        cell?.time_lab.text = dateFormatter.stringFromDate(diary.createdAt)
        cell?.content_lab.text = diary.content
        return cell!
    }
    
    func refreshData() {
        diarys.removeAll()
        queryAll()
    }

}

