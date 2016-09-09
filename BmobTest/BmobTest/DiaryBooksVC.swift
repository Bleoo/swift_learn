//
//  DiaryBooksVC.swift
//  BmobTest
//
//  Created by TDC on 16/9/6.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

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
    }
    
    override func viewDidAppear(animated: Bool) {
        queryDiaryBooks()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryBooks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DiaryBook", forIndexPath: indexPath) as? DiaryBookCell
        let book = diaryBooks[indexPath.row]
        cell?.subject_lab.text = book.subject
        return cell!
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
                self.diaryBooks = books
                self.books_cv.reloadData()
            }
        }
    }
    
    func createAction(){
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let createBookVC = mainSB.instantiateViewControllerWithIdentifier("CreateBookSB")
        navigationController?.pushViewController(createBookVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}