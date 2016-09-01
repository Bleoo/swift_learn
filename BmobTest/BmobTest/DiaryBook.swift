//
//  DiaryBook.swift
//  BmobTest
//
//  Created by TDC on 16/8/31.
//  Copyright © 2016年 TDC. All rights reserved.
//

import Foundation

class DiaryBook: BmobObject {
    
    var user: User?
    var unlockTime: NSDate?
    var subject: String?
    var isOpen: Bool?
    var diarys: [Diary]?
    var descript: String?
    
    static func convert(obj: BmobObject) -> DiaryBook {
        let diaryBook = DiaryBook.convertWithObject(obj)
        //不支持转化Bool，Int，Float类型,所以 需要手动设置
        diaryBook.isOpen = obj.objectForKey("isOpen") as? Bool
        return diaryBook
    }
    
    static func queryBooksByUserId(userId: String) -> [DiaryBook] {
        var books = [DiaryBook]()
        //关联对象表
        let query = BmobQuery(className: "DiaryBook")
        //需要查询的列
        let user = BmobObject(withoutDataWithClassName: "_User", objectId: userId)
        
        query.whereObjectKey("books", relatedTo: user)
        query.findObjectsInBackgroundWithBlock { (array, error) in
            for obj in array {
                let book = convert(obj as! BmobObject)
                print("username \(book.objectId)")
                books.append(book)
            }
        }
        return books
    }
    
}