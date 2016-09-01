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
    var picture: String?
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
    
}
