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
    var bookPic: BmobFile?
    
    static func convert(obj: BmobObject) -> DiaryBook {
        let diaryBook = DiaryBook.convertWithObject(obj)
        //不支持转化Bool，Int，Float类型,所以 需要手动设置
        diaryBook.isOpen = obj.objectForKey("isOpen") as? Bool
        return diaryBook
    }
    
    static func queryBooksByUserId(userId: String, handler: ([DiaryBook], NSError!) -> ()) {
        var books = [DiaryBook]()
        //关联对象表
        let query = BmobQuery(className: "DiaryBook")
        //需要查询的列
        let user = BmobObject(outDataWithClassName: "_User", objectId: userId)
        
        query.whereObjectKey("books", relatedTo: user)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (array, error) in
            if error == nil {
                for obj in array {
                    let book = convert(obj as! BmobObject)
                    books.append(book)
                }
            }
            handler(books, error)
        }
    }
    
    static func createNewBook(bookPic: NSData?, unlockTime: NSDate, subject: String, isOpen: Bool, descript: String?, handler: (Bool, NSError!) -> ()){
        if bookPic != nil {
            uploadFile(bookPic!) { (isSuccessful, error, file) in
                if isSuccessful && error == nil {
                    insert(file, unlockTime: unlockTime, subject: subject, isOpen: isOpen, descript: descript, handler: { (isSuccessful, error) in
                        handler(isSuccessful, error)
                    })
                } else {
                    print("图片上传失败")
                    handler(isSuccessful, error)
                }
            }
        } else {
            insert(nil, unlockTime: unlockTime, subject: subject, isOpen: isOpen, descript: descript, handler: { (isSuccessful, error) in
                handler(isSuccessful, error)
            })
        }
    }
    
    static func insert(bookPic: BmobFile?, unlockTime: NSDate, subject: String, isOpen: Bool, descript: String?, handler: (Bool, NSError!) -> ()){
        let obj = BmobObject(className: "DiaryBook")
        let user = BmobUser.currentUser()
        if bookPic != nil {
            obj.setObject(bookPic, forKey: "bookPic")
        }
        obj.setObject(user, forKey: "user")
        obj.setObject(unlockTime, forKey: "unlockTime")
        obj.setObject(subject, forKey: "subject")
        obj.setObject(isOpen, forKey: "isOpen")
        obj.setObject(descript, forKey: "descript")
        obj.saveInBackgroundWithResultBlock { (isSuccessful, error) in
            if isSuccessful && error == nil {
                let user = BmobUser.currentUser()
                let relation = BmobRelation()
                relation.addObject(obj)
                user.addRelation(relation, forKey: "books")
                user.updateInBackgroundWithResultBlock({ (isSuccessful, error) in
                    handler(isSuccessful, error)
                })
            } else {
                print("添加失败")
                handler(isSuccessful, error)
            }
        }
    }
    
    static func uploadFile(data: NSData, handler: (Bool, NSError!, BmobFile) -> ()){
        let file = BmobFile(fileName: String.random(32) + ".jpg", withFileData: data)
        file.saveInBackgroundByDataSharding { (isSuccessful, error) in
            handler(isSuccessful, error, file)
        }
    }
    
    static func update(bookPic: NSData?, unlockTime: NSDate?, subject: String?, isOpen: Bool?, descript: String?, handler: (Bool, NSError!) -> ()){
        
    }
    
}