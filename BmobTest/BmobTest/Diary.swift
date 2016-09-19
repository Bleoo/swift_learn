//
//  Diary.swift
//  BmobTest
//
//  Created by TDC on 16/8/31.
//  Copyright © 2016年 TDC. All rights reserved.
//

import Foundation

class Diary: BmobObject {
    
    var user: User?
    var picture: BmobFile?
    var isImportant: Bool?
    var content: String?
    var book: DiaryBook?
    var comments: [Comment]?
    
    static func convert(obj: BmobObject) -> Diary {
        let diary = Diary.convertWithObject(obj)
        //不支持转化Bool，Int，Float类型,所以 需要手动设置
        diary.user = User.convert(obj.objectForKey("user") as! BmobObject)
        diary.isImportant = obj.objectForKey("isImportant") as? Bool
        diary.book = DiaryBook.convert(obj.objectForKey("book") as! BmobObject)
        return diary
    }
    
    static func queryAll() -> [Diary] {
        var diarys = [Diary]()
        //查找表
        let query = BmobQuery(className: "Diary")
        query.includeKey("user,book")
        query.findObjectsInBackgroundWithBlock { (array, error) in
            for obj in array{
                let diary = convert(obj as! BmobObject)
                diarys.append(diary)
            }
        }
        return diarys
    }
    
    static func createDiary(picture: NSData?, isImportant: Bool, content: String, book: DiaryBook, handler: (Bool, NSError!) -> ()){
        if picture != nil {
            DiaryBook.uploadFile(picture!) { (isSuccessful, error, pic) in
                if isSuccessful && error == nil {
                    insert(pic, isImportant: isImportant, content: content, book: book, handler: handler)
                } else {
                    handler(isSuccessful, error)
                }
            }
        } else {
            insert(nil, isImportant: isImportant, content: content, book: book, handler: handler)
        }
    }
    
    static func insert(picture: BmobFile?, isImportant: Bool, content: String, book: DiaryBook, handler: (Bool, NSError!) -> ()) {
        let obj = BmobObject(className: "Diary")
        obj.setObject(BmobUser.currentUser(), forKey: "user")
        if picture != nil {
            obj.setObject(picture, forKey: "picture")
        }
        obj.setObject(isImportant, forKey: "isImportant")
        obj.setObject(content, forKey: "content")
        obj.setObject(book, forKey: "book")
        obj.saveInBackgroundWithResultBlock { (isSuccessful, error) in
            if isSuccessful && error == nil {
                let relation = BmobRelation()
                relation.addObject(obj)
                book.addRelation(relation, forKey: "diarys")
                book.updateInBackgroundWithResultBlock(handler)
            } else {
                handler(isSuccessful, error)
            }
        }
    }
    
}
