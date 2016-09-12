//
//  DiaryBooksVC.swift
//  BmobTest
//
//  Created by TDC on 16/9/6.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

typealias UpdateList = () -> ()

class DiaryBooksVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var books_cv: UICollectionView!
    
    var diaryBooks = [DiaryBook]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的日记本"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "创建", style: UIBarButtonItemStyle.Plain, target: self, action: "createAction")
        
        books_cv.dataSource = self
        books_cv.delegate = self
        books_cv.registerNib(UINib(nibName: "DiaryBookCell", bundle: nil), forCellWithReuseIdentifier: "DiaryBook")
        queryDiaryBooks()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryBooks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DiaryBook", forIndexPath: indexPath) as? DiaryBookCell
        let book = diaryBooks[indexPath.row]
        cell?.subject_lab.text = book.subject
        cell?.bookPic_img.image = UIImage(named: "book")
        if let url = book.bookPic?.url {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            // 切到全局队列,这是系统提供的并行队列
            dispatch_async(queue, { () -> Void in
                if let nsUrl = NSURL(string: url){
                    if let img = NSData(contentsOfURL: nsUrl) {
                        // 切回主队列
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            cell?.bookPic_img.image = UIImage(data: img)
                        }
                    }
                }
            })
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let createBookVC = mainSB.instantiateViewControllerWithIdentifier("CreateBookSB") as! CreateBookVC
        createBookVC.diaryBook = diaryBooks[indexPath.row]
        navigationController?.pushViewController(createBookVC, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (Utils.width-30)/3, height: Utils.height/3)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func queryDiaryBooks(){
        DiaryBook.queryBooksByUserId(BmobUser.currentUser().objectId) { (books, error) -> () in
            if error == nil {
                self.diaryBooks.removeAll()
                self.diaryBooks.appendContentsOf(books)
            }
            self.books_cv.reloadData()
        }
    }
    
    func createAction(){
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let createBookVC = mainSB.instantiateViewControllerWithIdentifier("CreateBookSB") as! CreateBookVC
        createBookVC.updateBlock = { () -> () in
            self.queryDiaryBooks()
        }
        navigationController?.pushViewController(createBookVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}