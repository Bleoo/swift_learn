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
        //背景色和tint颜色都要清除,保证自定义下拉视图高度自适应
//        refreshControl.backgroundColor = UIColor.clearColor()
//        refreshControl.tintColor = UIColor.clearColor()
        refreshControl.attributedTitle = NSAttributedString(string: "最后更新于\(NSDate())")
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
        print(indexPath.row)
        var cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell") as? DiaryCell
        if cell == nil {
            cell = DiaryCell(style: .Default, reuseIdentifier: "DiaryCell")
        }
        let diary = diarys[indexPath.row]
        cell?.user_btn.setTitle(diary.user?.username, forState: UIControlState.Normal)
        cell?.book_btn.setTitle(diary.book?.subject, forState: UIControlState.Normal)
        cell?.time_lab.text = dateFormatter.stringFromDate(diary.createdAt)
        cell?.content_lab.text = diary.content
        
        if let url = diary.user?.icon?.url {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            // 切到全局队列,这是系统提供的并行队列
            dispatch_async(queue, { () -> Void in
                if let nsUrl = NSURL(string: url){
                    if let img = NSData(contentsOfURL: nsUrl) {
                        // 切回主队列
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell?.icon_img.image = UIImage(data: img)
                        })
                    }
                }
            })
        }
        return cell!
    }
    
    func refreshData() {
        diarys.removeAll()
        queryAll()
    }

}

